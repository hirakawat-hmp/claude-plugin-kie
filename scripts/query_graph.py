#!/usr/bin/env python3
"""Query the bundled kie.ai knowledge graph.

Usage: query_graph.py <question...> [--budget N] [--dfs]

Uses networkx (provided by the `graphifyy` package) to traverse graph.json
and return nodes relevant to the question, ranked by label term overlap.

Stdout: compact text lines of matched nodes + their 1-2 hop neighbors.
"""
import argparse
import json
import os
import sys
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("question", nargs="+", help="Query string")
    parser.add_argument("--budget", type=int, default=2000,
                        help="Approximate token budget for output (default 2000)")
    parser.add_argument("--dfs", action="store_true",
                        help="Use depth-first traversal instead of BFS")
    parser.add_argument("--depth", type=int, default=2,
                        help="Max traversal depth (default 2)")
    parser.add_argument("--graph", type=Path,
                        default=Path(os.environ.get("CLAUDE_PLUGIN_ROOT",
                                                    Path(__file__).resolve().parent.parent))
                        / "graph" / "graph.json",
                        help="Path to graph.json (default: plugin's bundled graph)")
    args = parser.parse_args()

    try:
        import networkx as nx
        from networkx.readwrite import json_graph
    except ImportError:
        print("error: networkx not found. This script requires `graphifyy`.",
              file=sys.stderr)
        print("Install with: uv tool install graphifyy", file=sys.stderr)
        return 3

    if not args.graph.exists():
        print(f"error: graph file not found: {args.graph}", file=sys.stderr)
        return 2

    data = json.loads(args.graph.read_text())
    G = json_graph.node_link_graph(data, edges="links")

    question = " ".join(args.question)
    terms = [t.lower() for t in question.split() if len(t) > 2]

    # Rank nodes by label term overlap
    scored = []
    for nid, ndata in G.nodes(data=True):
        label = ndata.get("label", "").lower()
        score = sum(1 for t in terms if t in label)
        if score > 0:
            scored.append((score, nid))
    scored.sort(reverse=True)
    start_nodes = [nid for _, nid in scored[:3]]

    if not start_nodes:
        print(f"No matching nodes found for terms: {terms}", file=sys.stderr)
        return 0

    # Traverse
    subgraph_nodes = set(start_nodes)
    subgraph_edges = []

    if args.dfs:
        visited = set()
        stack = [(n, 0) for n in reversed(start_nodes)]
        while stack:
            node, d = stack.pop()
            if node in visited or d > args.depth + 4:  # DFS goes deeper
                continue
            visited.add(node)
            subgraph_nodes.add(node)
            for nb in G.neighbors(node):
                if nb not in visited:
                    stack.append((nb, d + 1))
                    subgraph_edges.append((node, nb))
    else:
        frontier = set(start_nodes)
        for _ in range(args.depth):
            nxt = set()
            for n in frontier:
                for nb in G.neighbors(n):
                    if nb not in subgraph_nodes:
                        nxt.add(nb)
                        subgraph_edges.append((n, nb))
            subgraph_nodes.update(nxt)
            frontier = nxt

    # Rank by relevance for output
    def relevance(nid):
        label = G.nodes[nid].get("label", "").lower()
        return sum(1 for t in terms if t in label)

    ranked = sorted(subgraph_nodes, key=relevance, reverse=True)

    lines = [
        f"Query: {question!r}",
        f"Matched start nodes: {[G.nodes[n].get('label', n) for n in start_nodes]}",
        f"Subgraph: {len(subgraph_nodes)} nodes, {len(subgraph_edges)} edges "
        f"({'DFS' if args.dfs else 'BFS'}, depth={args.depth})",
        "",
    ]
    for nid in ranked:
        d = G.nodes[nid]
        src = d.get("source_file", "") or ""
        if src and len(src) > 60:
            src = "..." + src[-57:]
        lines.append(f"  NODE {d.get('label', nid)}  [{src}]")
    lines.append("")
    for u, v in subgraph_edges:
        if u in subgraph_nodes and v in subgraph_nodes:
            ed = G.edges[u, v]
            lines.append(
                f"  EDGE {G.nodes[u].get('label', u)} "
                f"--{ed.get('relation', '?')} [{ed.get('confidence', '')}]--> "
                f"{G.nodes[v].get('label', v)}"
            )

    output = "\n".join(lines)
    char_budget = args.budget * 4
    if len(output) > char_budget:
        output = output[:char_budget] + f"\n... (truncated at ~{args.budget} token budget)"

    print(output)
    return 0


if __name__ == "__main__":
    sys.exit(main())

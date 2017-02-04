Edge = Struct.new(:parent, :child, :capacity)

Vertex = Struct.new(:id) do
  def edges
    @edges ||= {}
  end

  def each_edge
    edges.each do |_, multiple|
      multiple.each do |edge|
        yield edge, edge.child
      end
    end
  end

  def link(vertex, capacity = 0)
    edges[vertex] ||= []
    edges[vertex] << Edge[self, vertex, capacity]
    self
  end
end

class BFS
  def self.search(start, finish, &filter)
    queue   = [start]
    visited = {start => true}
    path    = {}
    found   = false

    while queue.any? && !found
      current = queue.shift

      if current == finish
        found = true
        break
      end

      current.each_edge do |edge, vertex|
        next if filter && !filter.call(edge)

        if !visited[vertex]
          visited[vertex] = true
          path[vertex]    = current

          queue << vertex
        end
      end
    end

    found ? path : false
  end
end

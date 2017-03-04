require 'spec_helper'
require './lib/breadth_first_search'

describe BFS do
  it 'returns the vertices in order they were found' do
    start  = BFS::Node[0]
    finish = BFS::Node[1]
    start.link(finish)

    path, _ = BFS.search(start, finish)
    expect(path).to eq({finish => start})
  end

  it 'handles multiple edges to same node' do
    start  = BFS::Node[0]
    finish = BFS::Node[1]
    start.link(finish)
    start.link(finish)

    expect(start.edges[finish].size).to eq 2

    path, _ = BFS.search(start, finish)
    expect(path).to eq({finish => start})
  end

  it 'avoids loops' do
    start  = BFS::Node[0]
    mid    = BFS::Node[1]
    finish = BFS::Node[3]

    start.link(mid)
    mid.link(mid)

    path, _ = BFS.search(start, finish)
    expect(path).to be_falsey
  end

  it 'returns false if no node was found' do
    start  = BFS::Node[0]
    finish = BFS::Node[1]

    path, _ = BFS.search(start, finish)
    expect(path).to be_falsey
  end

  it 'lets you decide which edges should be used' do
    start  = BFS::Node[0]
    finish = BFS::Node[1]
    start.link(finish, capacity: 0)

    path, edges = BFS.search(start, finish) do |edge|
      edge.fetch(:capacity) <= 0
    end

    expect(path).to be_falsey
  end
end

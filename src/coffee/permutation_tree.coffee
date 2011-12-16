###!
###
class_map = ((class_map) ->
  class_map["object #{name}"] = name.toLowerCase() for name in '''
    Boolean
    Number
    String
    Function
    Array
    Date
    RegExp
    Object
  '''.split(/\n/g)

  class_map
)({})

###!
###
type_of = (obj) -> if obj? then class_map[toString.call(obj)] or 'object'

###!
###
is_array = Array.isArray || (obj) -> type_of(obj) is 'array'

###!
###
class OrderedMap extends Array
  constructor: (pairs = []) -> @map_all pairs

  map: (key, value) ->
    unless @has key
      @[key] = value
      @push [key, value]

      this
    else
      @unmap key
      @map key, value

  map_all: (pairs) ->
    if is_array pairs
      @map(key, value) for [key, value] in pairs
    else
      (@map(key, value) if pairs.hasOwnProperty(key)) for key, value of pairs

    this

  unmap: (key) ->
    unless (index = @indexOf key) is -1
      delete @[key]
      @splice(index, 1)

    this

  unmap_all: (keys) ->
    if is_array keys
      @unmap(key) for key in keys
    else
      (@unmap key if keys.hasOwnProperty(key)) for key of keys

    this

  has: (key) -> @hasOwnProperty(key)

###!
###
class PermutationTree
  sizes: {}

  constructor: (@nodes, index = 0) -> @tree = @build_tree nodes

  size_of_tree: (height) ->
    return @sizes[height] if height of @sizes

    @sizes[height] = if height <= 1
      1
    else
      (1 + @size_of_tree (height - 1)) * height

  build_tree: (nodes) ->
    unless nodes.length
      []
    else
      tree = nodes.slice()
      for node, index in nodes
        tree.push.apply tree, @build_tree nodes[0...index].concat(nodes[index + 1..])
      tree

  shuffle: (shuffled = [], index = 0, offset = null, level = 0) ->
    height = @nodes.length - level

    if height is 0
      shuffled
    else
      unless level is 0
        index += offset * @size_of_tree(height) + (height - offset + 1)

      offset = Math.floor (height * Math.random())
      index += offset

      shuffled.push @tree[index]

      @shuffle shuffled, index, offset, (level + 1)

factorial_tree = new PermutationTree([1, 2, 3, 4, 5, 6, 7, 8, 9])

console.log '--------------------------------------------------------------------------------'
console.log "|nodes| = #{factorial_tree.nodes.length}"
console.log '--------------------------------------------------------------------------------'
console.log "|tree| = #{factorial_tree.tree.length}"
console.log '--------------------------------------------------------------------------------'
console.log "shuffle = #{factorial_tree.shuffle()}"
console.log '--------------------------------------------------------------------------------'


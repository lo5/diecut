test = require 'tape'
diecut = require './diecut.js'

isArray = (a) -> a and a.constructor is Array
isFunction = (f) -> 'function' is typeof f

test 'one template', (t) ->
  t.plan 2
  tag = diecut 'div'
  t.ok (not isArray tag), 'returns scalar'
  t.ok (isFunction tag), 'returns function'

test 'multiple templates return multiple builders', (t) ->
  t.plan 3
  [ tag1, tag2 ] = tags = diecut 'div', 'a'
  t.ok (isArray tags), 'returns array'
  t.ok (isFunction tag1), 'returns function'
  t.ok (isFunction tag2), 'returns function'

test 'caching', (t) ->
  t.plan 3
  [ tag1, tag2, tag3 ] = diecut 'div', 'div', 'a'
  t.equal tag1, tag2
  t.notEqual tag1, tag3
  t.notEqual tag2, tag3

test 'no args', (t) ->
  t.plan 1
  tag = diecut()
  t.equal tag(), '<div></div>'

verify = (t, template, content, args..., expected) ->
  tag = diecut template
  actual = if args.length
    tag.apply null, [ content ].concat args
  else
    tag content

  t.equal actual, expected

test 'falsy', (t) ->
  t.plan 9

  verify t, undefined, undefined, '<div></div>'
  verify t, undefined, null, '<div></div>'
  verify t, undefined, '', '<div></div>'

  verify t, null, undefined, '<div></div>'
  verify t, null, null, '<div></div>'
  verify t, null, '', '<div></div>'

  verify t, '', undefined, '<div></div>'
  verify t, '', null, '<div></div>'
  verify t, '', '', '<div></div>'

test 'with content', (t) ->
  t.plan 1
  verify t, '', 'content', '<div>content</div>'

test 'with contents', (t) ->
  t.plan 1
  verify t, '', [ 'content1', 'content2' ], '<div>content1content2</div>'

test 'tags', (t) ->
  t.plan 22
  verify t, 'foo', 'content', '<foo>content</foo>'
  verify t, '#foo', 'content', '<div id="foo">content</div>'
  verify t, 'foo#bar', 'content', '<foo id="bar">content</foo>'
  verify t, '.foo', 'content', '<div class="foo">content</div>'
  verify t, 'foo.bar', 'content', '<foo class="bar">content</foo>'
  verify t, '.foo.bar', 'content', '<div class="foo bar">content</div>'
  verify t, 'foo.bar.baz', 'content', '<foo class="bar baz">content</foo>'
  verify t, 'foo bar=baz', 'content', '<foo bar=baz>content</foo>'
  verify t, '#foo bar=baz', 'content', '<div id="foo" bar=baz>content</div>'
  verify t, 'foo#bar baz=qux', 'content', '<foo id="bar" baz=qux>content</foo>'
  verify t, '.foo bar=baz', 'content', '<div class="foo" bar=baz>content</div>'
  verify t, 'foo.bar baz=qux', 'content', '<foo class="bar" baz=qux>content</foo>'
  verify t, 'foo bar=$1', 'content', 'p', '<foo bar=p>content</foo>'
  verify t, 'foo bar=$1 baz=$2 qux=$3', 'content', 'p', 'q', 'r', '<foo bar=p baz=q qux=r>content</foo>'
  verify t, '#foo bar=$1', 'content', 'p', '<div id="foo" bar=p>content</div>'
  verify t, 'foo#bar baz=$1', 'content', 'p', '<foo id="bar" baz=p>content</foo>'
  verify t, '#foo bar=$1 baz=$2 qux=$3', 'content', 'p', 'q', 'r', '<div id="foo" bar=p baz=q qux=r>content</div>'
  verify t, 'foo#bar baz=$1 qux=$2 quux=$3', 'content', 'p', 'q', 'r', '<foo id="bar" baz=p qux=q quux=r>content</foo>'
  verify t, '.foo bar=$1', 'content', 'p', '<div class="foo" bar=p>content</div>'
  verify t, 'foo.bar baz=$1', 'content', 'p', '<foo class="bar" baz=p>content</foo>'
  verify t, '.foo bar=$1 baz=$2 qux=$3', 'content', 'p', 'q', 'r', '<div class="foo" bar=p baz=q qux=r>content</div>'
  verify t, 'foo.bar baz=$1 qux=$2 quux=$3', 'content', 'p', 'q', 'r', '<foo class="bar" baz=p qux=q quux=r>content</foo>'


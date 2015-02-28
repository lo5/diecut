argsRegExp = /\$(\d+)/g

isArray = (a) -> a and a.constructor is Array

compileBuilder = (template) ->
  template = template.trim()

  if 0 <= indexOfAttributes = template.indexOf ' '
    tagNameAndClasses = template.substr 0, indexOfAttributes
    attributes = template.substr indexOfAttributes
  else
    tagNameAndClasses = template

  [ tagName, classes... ] = tagNameAndClasses.split /\.+/g

  if 0 <= indexOfId = tagName.indexOf '#'
    id = tagName.substr indexOfId + 1
    tagName = tagName.substr 0, indexOfId

  tagName = 'div' if tagName is ''

  beginTag = "<#{tagName}"
  beginTag += " id=\"#{id}\"" if id
  beginTag += " class=\"#{classes.join ' '}\"" if classes.length
  beginTag += attributes if attributes
  beginTag += ">"
  closeTag = "</#{tagName}>"

  (contents='', args...) ->
    content = if contents.constructor is Array
      contents.join ''
    else
      contents

    tag = if args.length
      beginTag.replace argsRegExp, (match, submatch) ->
        if (argIndex = parseInt submatch) > 0 then args[argIndex - 1] else ''
    else
      beginTag

    tag + content + closeTag

_builderCache = {}
createBuilder = (template='div') ->
  if cached = _builderCache[template]
    cached
  else
    _builderCache[template] = compileBuilder template

createBuilders = (templates) ->
  for template in templates
    createBuilder template or null

diecut = (templates...) ->
  if templates.length > 1
    createBuilders templates
  else
    createBuilder templates[0]

if module?.exports?
  module.exports = diecut
else
  window.diecut = diecut

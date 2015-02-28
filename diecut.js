// Generated by CoffeeScript 1.9.1
(function() {
  var _builderCache, argsRegExp, compileBuilder, createBuilder, createBuilders, diecut, isArray,
    slice = [].slice;

  argsRegExp = /\$(\d+)/g;

  isArray = function(a) {
    return a && a.constructor === Array;
  };

  compileBuilder = function(template) {
    var attributes, beginTag, classes, closeTag, id, indexOfAttributes, indexOfId, ref, tagName, tagNameAndClasses;
    template = template.trim();
    if (0 <= (indexOfAttributes = template.indexOf(' '))) {
      tagNameAndClasses = template.substr(0, indexOfAttributes);
      attributes = template.substr(indexOfAttributes);
    } else {
      tagNameAndClasses = template;
    }
    ref = tagNameAndClasses.split(/\.+/g), tagName = ref[0], classes = 2 <= ref.length ? slice.call(ref, 1) : [];
    if (0 <= (indexOfId = tagName.indexOf('#'))) {
      id = tagName.substr(indexOfId + 1);
      tagName = tagName.substr(0, indexOfId);
    }
    if (tagName === '') {
      tagName = 'div';
    }
    beginTag = "<" + tagName;
    if (id) {
      beginTag += " id=\"" + id + "\"";
    }
    if (classes.length) {
      beginTag += " class=\"" + (classes.join(' ')) + "\"";
    }
    if (attributes) {
      beginTag += attributes;
    }
    beginTag += ">";
    closeTag = "</" + tagName + ">";
    return function() {
      var args, content, contents, tag;
      contents = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      if (contents == null) {
        contents = '';
      }
      content = contents.constructor === Array ? contents.join('') : contents;
      tag = args.length ? beginTag.replace(argsRegExp, function(match, submatch) {
        var argIndex;
        if ((argIndex = parseInt(submatch)) > 0) {
          return args[argIndex - 1];
        } else {
          return '';
        }
      }) : beginTag;
      return tag + content + closeTag;
    };
  };

  _builderCache = {};

  createBuilder = function(template) {
    var cached;
    if (template == null) {
      template = 'div';
    }
    if (cached = _builderCache[template]) {
      return cached;
    } else {
      return _builderCache[template] = compileBuilder(template);
    }
  };

  createBuilders = function(templates) {
    var i, len, results, template;
    results = [];
    for (i = 0, len = templates.length; i < len; i++) {
      template = templates[i];
      results.push(createBuilder(template || null));
    }
    return results;
  };

  diecut = function() {
    var templates;
    templates = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (templates.length > 1) {
      return createBuilders(templates);
    } else {
      return createBuilder(templates[0]);
    }
  };

  if ((typeof module !== "undefined" && module !== null ? module.exports : void 0) != null) {
    module.exports = diecut;
  } else {
    window.diecut = diecut;
  }

}).call(this);
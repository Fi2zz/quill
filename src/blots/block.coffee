Parchment = require('parchment')

NEWLINE_LENGTH = 1

class Block extends Parchment.Block
  @blotName = 'block'
  @tagName = 'P'

  constructor: (value) ->
    this.formats = {}
    super(value)
    this.ensureBreak()

  deleteAt: (index, length) ->
    if (index + length == this.getLength() and this.next?)
      this.next.moveChildren(this)
      length -= NEWLINE_LENGTH
    super(index, length)
    this.ensureBreak()

  ensureBreak: ->
    if this.getLength() == NEWLINE_LENGTH
      this.appendChild(Parchment.create('break'))

  getLength: ->
    return super() + NEWLINE_LENGTH;

  insertAt: (index, value, def) ->
    return super(index, value, def) if def?
    return if value.length == 0
    lines = value.split('\n')
    text = lines.shift()
    this.insertAt(index, text)
    if (lines.length > 0)
      next = this.split(index + text.length, true)
      next.insertAt(0, lines.join('\n'))

  insertBefore: (blot, ref) ->
    if this.children.head? && this.children.head.statics.blotName == 'break'
      br = this.children.head
    super(blot, ref)
    br.remove() if br?


Parchment.define(Block)

module.exports = Block

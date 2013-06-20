assert = require 'assert'
bf     = require '../barefoot'

double = (x, done) -> done null, x * 2

describe 'barefoot', ->
	describe 'chain', ->
		it 'should return 32', ->
			fn = bf.chain [
				double
				double
				bf.chain [
					double
					double
					double
				]
			]

			fn 1, (err, res) ->
				assert.equal 32, res
				assert.equal err, null

  describe 'check', ->
    schema =
      _a: Number
      _b: Boolean
      _c: String
      _d: /^[0-5]+$/
      _e: (v) -> v < 50
      _f: ['dick', 'jane']
      _g:
        a: Number
        b: String
      h: 1
      _i: [String]

    it 'should validate all fields', ->
      obj =
        a: 2
        b: true
        c: 'hey'
        d: '42'
        e: 24
        f: 'dick'
        g:
          a: 2
          b: 'hi'
        h: 'sup?'
        i: ['hey', 'there']

      res = bf.check obj, schema
      assert.equal res, true

    it 'should not require optional fields', ->
      obj =
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, true

    it 'should validate numbers', ->
      obj =
        a: 'hi'
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should validate booleans', ->
      obj =
        b: 'hi'
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should validate strings', ->
      obj =
        c: 2
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should validate regexps', ->
      obj =
        d: '92'
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should use validation functions', ->
      obj =
        e: 90
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should validate enums', ->
      obj =
        f: 'bob'
        h: 'sup?'

      res = bf.check obj, schema
      assert.equal res, false

    it 'should validate typed arrays', ->
      obj =
        f: 'bob'
        i: [2, 'hey']

      res = bf.check obj, schema
      assert.equal res, false

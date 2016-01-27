// setup

	var test = require("unit.js");
	
// tests 

	describe('This is a suite', function() {
	
		it('This is a passing test case', function() {
		
			test.assert(true === true);
	
		});

		it('This is a failing test case', function() {
		
			test.assert(true === false);
	
		});
		
		it('This is a passing test case', function() {
		
			test.assert(true === true);
	
		});
					    
	});

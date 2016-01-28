// setup

	var test = require("unit.js");
	
// tests 

	describe('This is a suite in a disabled test file', function() {
	
		it('This is a failing test case in a disabled test file', function() {
		
			test.assert(true === false);
	
		});

		it('This is a passing test case in a disabled test file', function() {
		
			test.assert(true === true);
	
		});
			    
	});

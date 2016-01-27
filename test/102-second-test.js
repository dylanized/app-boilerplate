// setup

	var test = require("unit.js");
	
// tests 

	describe('This is a suite', function() {
	
		it('This is supposed to pass', function() {
		
			test.assert(true === true);
	
		});

		it('This is supposed to fail', function() {
		
			test.assert(true === false);
	
		});
		
		it('This is supposed to be skipped if used with --bail', function() {
		
			test.assert(true === true);
	
		});
					    
	});

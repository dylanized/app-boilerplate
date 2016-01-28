# App Name

App description goes here.

## Quick Info

#### Dev

- URL: 
- DB: 
- Log: 

#### Staging

- URL: 
- DB: 
- Log: 
- Deploy:

#### Production

- URL: 
- DB: 
- Log:
- Deploy:

## Tasks

#### Building

- `npm install`
  - Installs NPM and Bower modules, then runs the build
- `npm update`
  - Updates NPM and Bower modules
- `npm run build`
  - Compiles CSS & JS
- `npm run compile-css`
  - Compiles CSS
- `npm run compile-js`
  - Compiles JS
  
#### Watching

- `npm run watch`
  - Launch all watch scripts
- `npm run watch-css`
  - Watch CSS source and compile on change
- `npm run watch-js`
  - Watch JS source and compile on change
- `npm run watch-server`
  - Watch compiled assets and restart server on change

#### Running  
  
- `npm start`
  - Starts server and master process
- `npm run build-start`
  - Runs the build and starts server
- `npm run watch-start`
  - Laucnh watch scripts and start the server 
- `npm run dev`
  - Reload db, run the build, then watch-start
- `npm stop`
  - Shut down databases
- `npm restart`
  - Stop then start again
  
#### Testing  
  
- `npm test`
  - Runs active Mocha test files
  - Stops after first failure
- `npm run test-all` or `npm run mocha`
  - Runs all Mocha test files
  - Does not stop after failures
- `npm run test-file <file>`
  - Run single test file or subset files in the /test folder
  - Optionally add `-- --bail` to bail on first failure
- `npm run test-grep <term>`
  - Run test files containing `<term>`
  - Optionally add `-- --bail` to bail on first failure 
- `npm run env`
  - Print out NPM environment variables
- `npm run bin`
  - Show installed binaries
  
#### Database Tasks 
  
- `npm run createDB`
  - Creates the database
- `npm run importDB <file>`
  - Imports file to database
- `npm run seedDB`
  - Imports seed file to database (defined in `package.json`)
- `npm run dropDB`
  - Drops database
- `npm run reloadDB`
  - Executes `npm run dropDB && npm run seedDB`
- `npm run exportDB <file>`
  - Exports database to `<file>`
- `npm run startDB`
  - Starts database process
- `npm run stopDB`
  - Stops database process
- `npm run destroyDB`
  - Destroy database
  
#### 2nd Database Tasks 
  
- `npm run createSQL`
- `npm run importSQL <file>`
- `npm run seedSQL`
- `npm run dropSQL`
- `npm run reloadSQL`
- `npm run exportSQL <file>`
- `npm run startSQL`
- `npm run stopSQL`
- `npm run destroyDB`

#### Cleanup Tasks  

- `npm run clean`
  - Delete temp files
- `npm uninstall`
  - Destroy databases
  
#### Other Tasks  

- `npm run cron`
  - Maintenance task that is run regularly
- `npm run archive`
  - Occasional archive task

## Architecture Notes

#### Section #1

- note #1
- note #2

#### Section #2

- note #1
- note #2

## Devops Notes

#### Cron Jobs

**Cron Job #1**

- details
  
**Cron Job #2**

- details

#### Build System

- step #1
- step #2

## User Roles

#### Role #1

#### Role #2

## API Endpoints

#### Endpoint Group #1

| Name        | Path                |
| ----------- | ------------------- |
| Endpoint #1 | `/path/to/endpoint` |
| Endpoint #2 | `/path/to/endpoint` |

**Details**

- Path: /link
- Request type: POST
- Content: form-encoded data

**Fields**

- field #1
- field #2

**Result**

- Content-Type: application/json
- Content:
	- prop #1
	- prop #2
	
## Setup	
	
#### App Dependencies

- dep #1
- dep #2

#### Dev Dependencies

- dep #1
- dep #2

#### Dev Install

1.
2.
3.

#### Dev Routine

1.
2.

#### Useful Dev Links

- http://a.com
- http://b.com

#### Staging Install

1.
2.
3.
4.
5.

#### Production Install

1.
2.
3.

## Database Details

For basic tasks, Tasks section above.

Other database actions:

#### Get Access

#### Create User

## Tests

| Name         | Details |
| ------------ | ------- |
| Test File #1 | details |
| Test File #2 | details |

To run tests, see Tasks section above. 

To deactivate tests, prefix the filename with an underscore.

## Credits

Main contributors:

- Contributor #1
- Contributor #2

(c) 2016 App Author
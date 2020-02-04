/*
 *Backend app configuration
 *For app specific configs, prefix with beconf. for consistency
 */


// use login preset
beconf.login.preset.host='irods.dh.local'
beconf.login.preset.port=1247
beconf.login.preset.zone='nlmumc'
beconf.login.preset.auth.type='Standard'
beconf.login.preset.enabled=true


// log4j configuration
log4j.main = {
	// Example of changing the log pattern for the default console appender:
	//
	appenders {
	    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
	}

	error	'org',
			'org.codehaus.groovy.grails.web.servlet',
			'org.irods',
			'org.irods.jargon.idrop.web.controllers',
      'grails.app',
      'org.irods.jargon'          

	error  'org.codehaus.groovy.grails.web.servlet',        // controllers
			'org.codehaus.groovy.grails.web.pages',          // GSP
			'org.codehaus.groovy.grails.web.sitemesh',       // layouts
			'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
			'org.codehaus.groovy.grails.web.mapping',        // URL mapping
			'org.codehaus.groovy.grails.commons',            // core / classloading
			'org.codehaus.groovy.grails.plugins',            // plugins
			'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
			'org.springframework',
			'org.hibernate',
			'net.sf.ehcache.hibernate'
}



// ORIGINAL log4j configuration
//log4j.main = {
	// Example of changing the log pattern for the default console appender:
	//
//	appenders {
//	    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
//	}

//	info	'org',
//			'org.codehaus.groovy.grails.web.servlet',
//			'org.irods',
//			'org.irods.jargon.idrop.web.controllers',
//            'grails.app'

//	debug "org.irods.jargon"
            

//	info  'org.codehaus.groovy.grails.web.servlet',        // controllers
//			'org.codehaus.groovy.grails.web.pages',          // GSP
//			'org.codehaus.groovy.grails.web.sitemesh',       // layouts
//			'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
//			'org.codehaus.groovy.grails.web.mapping',        // URL mapping
//			'org.codehaus.groovy.grails.commons',            // core / classloading
//			'org.codehaus.groovy.grails.plugins',            // plugins
//			'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
//			'org.springframework',
//			'org.hibernate',
//			'net.sf.ehcache.hibernate'
//}
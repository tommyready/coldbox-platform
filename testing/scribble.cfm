<cfscript>
out = createObject("java","java.lang.StringBuffer").init('');
tab = chr(9);
br  = chr(10);

out.append('<?xml version="1.0" encoding="UTF-8"?>
<dictionary>
	<tags></tags>
');

functions = {
	superType = "coldbox.system.FrameworkSuperType",
	eventHandler = "coldbox.system.EventHandler",
	plugin = "coldbox.system.Plugin",
	interceptor = "coldbox.system.Interceptor",
	testCase = "coldbox.system.testing.BaseTestCase"
};

for( key in functions ){
	
	md = getComponentMetaData( functions[key] );
	
	out.append('#tab#<scopevar name="#key#">
	#tab#<help><![CDATA[#md.hint#]]></help>
	');

	for(x=1; x lte arrayLen(md.functions); x++){
		out.append('#tab#<scopevar name="#md.functions[x].name#(');	
		
		// Args
		for( y=1; y lte arrayLen(md.functions[x].parameters); y++){
			if(NOT structKeyExists(md.functions[x].parameters[y],"required") ){
				md.functions[x].parameters[y].required = false;
			}
			out.append((md.functions[x].parameters[y].required ? '':'[') & '#md.functions[x].parameters[y].name#' & (md.functions[x].parameters[y].required ? '':']'));
			
			if( y le  ( arrayLen(md.functions[x].parameters)-1) ){
				out.append(",");
			} 
		}
		
		out.append(')">
		#tab#<help><![CDATA[#md.functions[x].hint#]]></help>#br##tab#');
	}
	
	out.append('</scopevar>#br#');
}

scopes = {
	controller = "coldbox.system.web.Controller",
	event = "coldbox.system.web.context.RequestContext",
	flash = "coldbox.system.web.flash.AbstractFlashScope",
	log = "coldbox.system.logging.Logger",
	logbox = "coldbox.system.logging.LogBox"
};
for( key in scopes ){
	
	md = getComponentMetaData( scopes[key] );
	
	out.append('#tab#<scopevar name="#key#">
	#tab#<help><![CDATA[#md.hint#]]></help>
	');

	for(x=1; x lte arrayLen(md.functions); x++){
		out.append('#tab#<scopevar name="#md.functions[x].name#(');	
		
		// Args
		for( y=1; y lte arrayLen(md.functions[x].parameters); y++){
			if(NOT structKeyExists(md.functions[x].parameters[y],"required") ){
				md.functions[x].parameters[y].required = false;
			}
			out.append((md.functions[x].parameters[y].required ? '':'[') & '#md.functions[x].parameters[y].name#' & (md.functions[x].parameters[y].required ? '':']'));
			
			if( y le  ( arrayLen(md.functions[x].parameters)-1) ){
				out.append(",");
			} 
		}
		
		out.append(')">
		#tab#<help><![CDATA[#md.functions[x].hint#]]></help>#br##tab#');
	}
	
	out.append('</scopevar>#br#');
}

out.append('</dictionary>');
</cfscript>

<textarea rows="30" cols="160">
<cfoutput>#out.toString()#</cfoutput>
</textarea>
<!--- Scope Vars:
	controller 
	event
	flash
	log
	logbox

Functions From the Following objects

Framework Super Type
Event Handler
Plugin
Interceptor
BaseTestCase
	
	
 --->
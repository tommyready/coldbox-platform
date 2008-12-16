<!-----------------------------------------------------------------------********************************************************************************Copyright 2005-2008 ColdBox Framework by Luis Majano and Ortus Solutions, Corpwww.coldboxframework.com | www.luismajano.com | www.ortussolutions.com********************************************************************************Serialize and deserialize JSON data into native ColdFusion objectshttp://www.epiphantastic.com/cfjson/Authors: Luis Majano & Peter BellModifications:	- Original by Peter Bell-----------------------------------------------------------------------><cfcomponent name="BaseConfigObject" output="false" hint="A base configuration object for lightwire"><!----------------------------------------- CONSTRUCTOR ------------------------------------->		<cfscript>		instance = structnew();	</cfscript>	<!--- Init --->	<cffunction name="init" returntype="BaseConfigObject" hint="I initialize default LightWire config properties." output="false">		<cfscript>			/* Default DI Lazy Load */			instance.LazyLoad = true;			/* Default Bean Lazy Init */			instance.defaultBeanLazyInit = true;			/* Setup the NonLazyBeans struct */			instance.nonLazyBeans = structnew();			/* Setup the default Config Struct */			instance.config = structnew();			/* Setup the Alias Struct */			instance.aliasStruct = structnew();			/* Lightwire utility */			instance.oUtil = createObject("component","coldbox.system.extras.lightwire.util.Utility");			/* Regex for JSON */			instance.jsonRegex = "^(\{|\[)(.)*(\}|\])$";			/* instance */			return this;		</cfscript>	</cffunction>	<!----------------------------------------- PUBLIC ------------------------------------->			<!--- get the config struct --->	<cffunction name="getConfigStruct" returntype="struct" hint="I provide LightWire with the properly configured configuration struct to operate on." output="false">		<cfreturn instance.config>	</cffunction>		<!--- Set the config Struct --->	<cffunction name="setConfigStruct" access="public" output="false" returntype="void" hint="Set or override the configuration struct.">
		<!---************************************************************************************************ --->		<cfargument name="ConfigStruct" type="struct" required="true"/>
		<!---************************************************************************************************ --->		<cfset instance.config = arguments.ConfigStruct/>
	</cffunction>		<!--- Set the lazy Load --->	<cffunction name="setLazyLoad" returntype="void" hint="I set whether Singletons should or shouldn't be laxy loaded." output="false">		<!---************************************************************************************************ --->		<cfargument name="LazyLoad" required="true" type="boolean" hint="Whether or not to use lazy loading of Singletons.">		<!---************************************************************************************************ --->		<cfset instance.LazyLoad = arguments.LazyLoad>	</cffunction>				<!--- Get the Lazy Load --->	<cffunction name="getLazyLoad" returntype="boolean" hint="I return whether Singletons should or shouldn't be lazy loaded." output="false">		<cfreturn instance.LazyLoad>	</cffunction>		<!--- Get The Alias Struct --->	<cffunction name="getAliasStruct" access="public" output="false" returntype="struct" hint="Get the AliasStruct">
		<cfreturn instance.AliasStruct/>
	</cffunction>		<!--- Get the non lazy beans --->	<cffunction name="getNonLazyBeans" access="public" output="false" returntype="struct" hint="Get the non Lazy Beans">
		<cfreturn instance.nonLazyBeans/>
	</cffunction>		<!--- Add a Singleton --->	<cffunction name="addSingleton" returntype="void" hint="I add the configuration properties for a Singleton." output="false">		<!---************************************************************************************************ --->		<cfargument name="FullClassPath" 	required="true"  type="string" 					hint="The full class path to the bean including its name. E.g. for com.UserService.cfc it would be com.UserService.">		<cfargument name="BeanName" 		required="false" type="string"	default="" 		hint="An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.UserService, it'll be named UserService unless you put something else here. If you put UserS, it'd be available as UserS, but NOT as UserService.">		<cfargument name="InitMethod" 		required="false" type="string"	default="" 		hint="A default custom initialization method for LightWire to call on the bean after constructing it fully (including setter and mixin injection) but before returning it.">		<cfargument name="Lazy" 			required="false" type="boolean" default="#instance.defaultBeanLazyInit#"	hint="Whether to construct at startup or not.">		<cfargument name="BeanType" 		required="false" type="string" 	default=""		hint="The bean type: cfc, java, webservice">		<cfargument name="Aliases" 			required="false" type="string"  default=""		hint="A comma-delimmitted list of aliases for this bean">		<!---************************************************************************************************ --->		<cfscript>			arguments.Singleton = 1;			addBean(argumentCollection=arguments);		</cfscript>	</cffunction>		<!--- Add a Transient Object --->	<cffunction name="addTransient" returntype="void" hint="I add the configuration properties for a Transient." output="false">		<!---************************************************************************************************ --->		<cfargument name="FullClassPath" 	required="true"  type="string" 				hint="The full class path to the bean including its name. E.g. for com.User.cfc it would be com.User.">		<cfargument name="BeanName" 		required="false" type="string" default=""  	hint="An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.User, it'll be named User unless you put something else here. If you put UserBean, it'd be available as UserBean, but NOT as User.">		<cfargument name="InitMethod" 		required="false" type="string" default="" 	hint="A default custom initialization method for LightWire to call on the bean after constructing it fully (including setter and mixin injection) but before returning it.">			<cfargument name="BeanType" 		required="false" type="string" default=""	hint="The bean type: cfc, java, webservice">		<cfargument name="Aliases" 			required="false" type="string"  default=""		hint="A comma-delimmitted list of aliases for this bean">		<!---************************************************************************************************ --->		<cfscript>			arguments.singleton = 0;			arguments.lazy = true;			addBean(argumentCollection=arguments);		</cfscript>	</cffunction>		<!--- Add a Bean --->	<cffunction name="addBean" returntype="void" hint="I add the configuration properties for a Singleton or Transient." output="false">		<!---************************************************************************************************ --->		<cfargument name="FullClassPath" 	required="true" 	type="string" 					hint="The full class path to the bean including its name. E.g. for com.UserService.cfc it would be com.UserService.">		<cfargument name="BeanName" 		required="false" 	type="string" 	default="" 		hint="An optional name to be able to use to refer to this bean. If you don't provide this, the name of the bean will be used as a default. E.g. for com.UserService, it'll be named UserService unless you put something else here. If you put UserS, it'd be available as UserS, but NOT as UserService.">		<cfargument name="Singleton" 		required="true" 	type="boolean"					hint="Whether the bean is a Singleton (1) or Transient(0).">		<cfargument name="InitMethod" 		required="false" 	type="string" 	default="" 		hint="A default custom initialization method for LightWire to call on the bean after constructing it fully (including setter and mixin injection) but before returning it.">			<cfargument name="Lazy" 			required="false" 	type="boolean" 	default="#instance.defaultBeanLazyInit#"	hint="Whether to construct at startup or not.">		<cfargument name="BeanType" 		required="false" 	type="string" 	default=""		hint="The bean type: cfc, java, webservice">		<cfargument name="Aliases" 			required="false" type="string"  default=""		hint="A comma-delimmitted list of aliases for this bean">		<!---************************************************************************************************ --->		<cfscript>			var beanDefintion = getBeanDefinition();			var x = 1;						// Default the name to the name of the bean if no name list is provided.			If (Len(trim(arguments.BeanName)) LT 1){				arguments.BeanName = ListLast(arguments.FullClassPath,".");			}						/* Setup Arguments */			beanDefintion.Singleton = arguments.Singleton;			beanDefintion.Path = arguments.FullClassPath;			beanDefintion.InitMethod = arguments.InitMethod;			beanDefintion.Lazy = arguments.Lazy;						/* Verify beanType */			beanDefintion.Type = validateBeanType(arguments.beanType);						/* Add to non lazy beans? */			if( not arguments.Lazy ){				addToNonLazyBeans(arguments.BeanName);			}						/* Aliases Check & Addition */			for(x=1; x lte listLen(Aliases); x=x+1){				instance.aliasStruct[listgetAt(Aliases,x)] = arguments.beanName;			}						/* Save in Config */			instance.config[arguments.BeanName] = beanDefintion;		</cfscript>	</cffunction>		<!--- Add a Singleton From a Factory --->	<cffunction name="addSingletonFromFactory" returntype="void" hint="Adds the definition for a given Singleton that is created by a factory to the config file." output="false">		<!---************************************************************************************************ --->		<cfargument name="FactoryBean" 		required="true" 	type="string" hint="The name of the factory to use to create this bean (the factory must also have been defined as a Singleton in the LightWire config file).">		<cfargument name="FactoryMethod" 	required="true" 	type="string" hint="The name of the method to call on the factory bean to create this bean.">		<cfargument name="BeanName" 		required="true" 	type="string" hint="The required name to use to refer to this bean.">		<cfargument name="Lazy" 			required="false" 	type="boolean" 	default="#instance.defaultBeanLazyInit#"	hint="Whether to construct at startup or not.">		<cfargument name="BeanType" 		required="false" 	type="string" 	default=""		hint="The bean type: cfc, java, webservice">		<!---************************************************************************************************ --->		<cfscript>			arguments.singleton = 1;			addBeanFromFactory(argumentCollection=arguments);		</cfscript>	</cffunction>		<!--- Add a transient from a factory --->	<cffunction name="addTransientFromFactory" returntype="void" hint="Adds the definition for a given Transient that is created by a factory to the config file." output="false">		<!---************************************************************************************************ --->		<cfargument name="FactoryBean" 		required="true" type="string" hint="The name of the factory to use to create this bean (the factory must also have been defined as a Singleton in the LightWire config file).">		<cfargument name="FactoryMethod" 	required="true" type="string" hint="The name of the method to call on the factory bean to create this bean.">		<cfargument name="BeanName" 		required="true" type="string" hint="The required name to use to refer to this bean.">		<cfargument name="BeanType" 		required="false" 	type="string" 	default=""		hint="The bean type: cfc, java, webservice">		<!---************************************************************************************************ --->		<cfscript>			arguments.singleton = 0;			arguments.lazy = true;			addBeanFromFactory(argumentCollection=arguments);		</cfscript>	</cffunction>		<!--- Add From Factory --->	<cffunction name="addBeanFromFactory" returntype="void" hint="I add the configuration properties for a Singleton or Transient that is created by a factory to the config file." output="false">		<!---************************************************************************************************ --->		<cfargument name="FactoryBean" 		required="true" 	type="string" 	hint="The name of the factory to use to create this bean (the factory must also have been defined as a Singleton in the LightWire config file).">		<cfargument name="FactoryMethod" 	required="true" 	type="string" 	hint="The name of the method to call on the factory bean to create this bean.">		<cfargument name="BeanName" 		required="true" 	type="string" 	hint="The required name to use to refer to this bean.">		<cfargument name="Singleton" 		required="true" 					hint="Whether the bean is a Singleton (1) or Transient(0).">		<cfargument name="Lazy" 			required="false" 	type="boolean" 	default="#instance.defaultBeanLazyInit#"	hint="Whether to construct at startup or not.">		<cfargument name="BeanType" 		required="false" 	type="string" 	default=""		hint="The bean type: cfc, java, webservice">		<!---************************************************************************************************ --->		<cfscript>			var beanDefintion = getBeanDefinition();						/* Setup Arguments. */			beanDefintion.Singleton = arguments.Singleton;			beanDefintion.FactoryBean = arguments.FactoryBean;			beanDefintion.FactoryMethod = arguments.FactoryMethod;			beanDefintion.isFactoryBean = true;			beanDefintion.Lazy = arguments.Lazy;			beanDefintion.Type = validateBeanType(arguments.beanType);						/* Add to non lazy beans? */			if( not arguments.Lazy ){				addToNonLazyBeans(arguments.BeanName);			}						/* Save in Config */			instance.config[arguments.BeanName] = beanDefintion;		</cfscript>	</cffunction>		<!--- Add a constructor Dependency --->	<cffunction name="addConstructorDependency" returntype="void" hint="I add a constructor object dependency for a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true"	 	type="string" 				hint="The name of the bean to set the constructor dependencies for.">		<cfargument name="InjectedBeanName" required="true" 	type="string" default="" 	hint="The name of the bean to inject.">		<cfargument name="PropertyName" 	required="false" 	type="string" default="" 	hint="The optional property name to pass the bean into. Defaults to the bean name if not provided.">		<!---************************************************************************************************ --->		<cfscript>			/* Name Resolution */			arguments.InjectedBeanName = nameResolution(arguments.InjectedBeanName);			// Add the constructor dependencies			If (len(PropertyName) LT 1){				arguments.PropertyName = arguments.InjectedBeanName;			}			instance.config[arguments.BeanName].ConstructorDependencyStruct[arguments.InjectedBeanName] = arguments.PropertyName;		</cfscript>	</cffunction>		<!--- Add a constructor property --->	<cffunction name="addConstructorProperty" returntype="void" hint="I add a constructor property of any type to a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true"  type="string" 	hint="The name of the bean to add the property to.">		<cfargument name="PropertyName" 	required="true"  type="string" 	hint="The name of the property to set.">		<cfargument name="PropertyValue" 	required="true"  type="any" 	hint="The value of the property to set.">		<cfargument name="CastTo" 			required="false" type="string" default="" 	hint="Used for java objects. Cast this property using javacast(): boolean,int,long,float,double,string,null">		<!---************************************************************************************************ --->		<cfscript>			var prop = structnew();			prop.value = arguments.PropertyValue;			prop.cast  = arguments.CastTo;			// Add the constructor property			instance.config[arguments.BeanName].ConstructorProperties[arguments.PropertyName] = prop;		</cfscript>	</cffunction>		<!--- Add a Setter Dependency --->	<cffunction name="addSetterDependency" returntype="void" hint="I add a setter dependency for a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true"  type="string" 			  hint="The name of the bean to set the setter dependencies for.">		<cfargument name="InjectedBeanName" required="true"  type="string" default="" hint="The name of the bean to inject.">		<cfargument name="PropertyName" 	required="false" type="string" default="" hint="The optional property name to pass the bean into. Defaults to the bean name if not provided.">		<!---************************************************************************************************ --->		<cfscript>			/* Name Resolution */			arguments.InjectedBeanName = nameResolution(arguments.InjectedBeanName);			// Add the setter dependencies			If (len(arguments.PropertyName) LT 1){				arguments.PropertyName = arguments.InjectedBeanName;			}			instance.config[arguments.BeanName].SetterDependencyStruct[arguments.InjectedBeanName] = arguments.PropertyName;		</cfscript>	</cffunction>		<!--- Add a setter property --->	<cffunction name="addSetterProperty" returntype="void" hint="I add a setter property of any type to a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true"  type="string" 	hint="The name of the bean to add the property to.">		<cfargument name="PropertyName" 	required="true"  type="string" 	hint="The name of the property to set.">		<cfargument name="PropertyValue" 	required="true"  type="any" 	hint="The value of the property to set.">		<cfargument name="CastTo" 			required="false" type="string" default="" 	hint="Used for java objects. Cast this property using javacast(): boolean,int,long,float,double,string,null">		<!---************************************************************************************************ --->		<cfscript>			var prop = structnew();			prop.value = arguments.PropertyValue;			prop.cast  = arguments.CastTo;			// Add the setter property			instance.config[arguments.BeanName].SetterProperties[arguments.PropertyName] = prop;		</cfscript>	</cffunction>		<!--- Add a mixin dependency --->	<cffunction name="addMixinDependency" returntype="void" hint="I add a mixin dependency for a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true" 	type="string" 				hint="The name of the bean to set the mixin dependencies for.">		<cfargument name="InjectedBeanName" required="true" 	type="string" default="" 	hint="The name of the bean to inject.">		<cfargument name="PropertyName" 	required="false" 	type="string" default="" 	hint="The optional property name to pass the bean into. Defaults to the bean name if not provided.">		<cfargument name="Scope" 			required="false" 	type="string" default="variables" hint="The scope this dependency will be injected into. The default is variables scope">		<!---************************************************************************************************ --->		<cfscript>			var prop = structnew();			/* Name Resolution */			arguments.InjectedBeanName = nameResolution(arguments.injectedBeanName);			// Add the mixin dependencies			If (len(PropertyName) LT 1){				arguments.PropertyName = arguments.InjectedBeanName;			}			/* Setup struct */			prop.propertyname = arguments.PropertyName;			prop.scope = arguments.Scope;			/* Save it */			instance.config[arguments.BeanName].MixinDependencyStruct[arguments.InjectedBeanName] = prop;		</cfscript>	</cffunction>			<!--- Add a mixin property --->	<cffunction name="addMixinProperty" returntype="void" hint="I add a mixin property of any type to a bean." output="false">		<!---************************************************************************************************ --->		<cfargument name="BeanName" 		required="true"  type="string" 	hint="The name of the bean to add the property to.">		<cfargument name="PropertyName" 	required="true"  type="string" 	hint="The name of the property to set.">		<cfargument name="PropertyValue" 	required="true"  type="any" 		hint="The value of the property to set.">		<cfargument name="Scope" 			required="false" type="string"  default="variables" hint="The scope this property will be injected into. The default is variables scope">		<!---************************************************************************************************ --->		<cfscript>			var prop = structnew();			prop.value = arguments.PropertyValue;			prop.scope = arguments.Scope;			// Add the mixin property			instance.config[arguments.BeanName].MixinProperties[arguments.PropertyName] = prop;		</cfscript>	</cffunction>		<!--- Parse a Coldspring XML --->	<cffunction name="parseXMLConfigFile" returntype="void" hint="I take the path to a ColdSpring XML config file and use it to set all of the necessary LightWire config properties." output="false">		<!---************************************************************************************************ --->		<cfargument name="XMLFilePath" 	required="true" 	type="string" hint="The path to the XML config file.">		<cfargument name="properties" 	required="false" 	type="struct" default="#structNew()#" hint="A struct of default properties to be used in place of ${key} in XML config file.">		<!---************************************************************************************************ --->		<cfscript>			/* Parse bean definitions*/			parseXMLRaw(getUtil().readFile(arguments.XMLFilePath),arguments.properties);		</cfscript>	</cffunction>		<!--- Parse XML Raw --->	<cffunction name="parseXMLRaw" access="public" returntype="void" hint="Parse an xml raw string" output="false" >		<!---************************************************************************************************ --->		<cfargument name="rawXML" 	required="true" 	type="string" hint="A raw string of xml bean definitions">		<cfargument name="properties" 	required="false" 	type="struct" default="#structNew()#" hint="A struct of default properties to be used in place of ${key} in XML config file.">		<!---************************************************************************************************ --->		<cfscript>			/* Raw Replacement */			arguments.rawXML = getUtil().placeHolderReplacer(arguments.rawXML,properties);			/* Parse bean definitions*/			parseXMLObj(XMLParse(arguments.rawXML,false),arguments.properties);		</cfscript>
	</cffunction>		<!--- Parse XML Object --->	<cffunction name="parseXMLObj" access="public" returntype="void" hint="Parse an xml object definition, replacement of placeholders are done in the Raw or ConfiFile Methods Only" output="false" >		<!---************************************************************************************************ --->		<cfargument name="XMLObj" 		required="true" 	type="xml" hint="The XML Object to parse.">		<cfargument name="properties" 	required="false" 	type="struct" default="#structNew()#" hint="A struct of default properties to be used in place of ${key} in XML config file.">		<!---************************************************************************************************ --->		<cfscript>			var i = 0;			var x = 0;			// parse coldspring xml bean config			var xml = arguments.XMLObj;			// use XMLSearch to create array of all bean defs			var beans = XMLSearch(xml,'/beans/bean');			var aliases = XMLSearch(xml,'/beans/alias');			var aliasesLen = arrayLen(aliases);			var aliasListLen = 0;						/* default-lazy-init? */			if( structKeyExists(xml.beans.XMLAttributes,"default-lazy-init") 				AND			    isBoolean(trim(xml.beans.XMLAttributes["default-lazy-init"])) ){				/* Set the lazy load argument. */				setLazyLoad(trim(xml.beans.XMLAttributes["default-lazy-init"]));			}						// loop over beans to create definitions from XML			for (i = 1; i lte ArrayLen(beans); i = i + 1){				/* Translate Bean Definition */				translateBean(beans[i],arguments.properties);			}						/* Loop Over Aliases */			for(x=1; x lte aliasesLen; x=x+1){				/* Attribute Checks */				if( NOT structKeyExists(aliases[x].xmlAttributes,"alias") OR NOT structKeyExists(aliases[x].xmlAttributes,"name") ){					getUtil().throwit('Wrong attributes for alias element',"Both an alias an a name are needed for an alias","LightWire.AliasAttributeException");				}				/* Loop Over Alias Value List */				aliasListLen = listLen(trim(aliases[x].XMLAttributes.alias));				for(i=1; i lte aliasListLen;i=i+1){					instance.aliasStruct[trim(listgetAt(aliases[x].XMLAttributes.alias,i))] = trim(aliases[x].XMLAttributes.name);				}			}		</cfscript>
	</cffunction>		<!--- Translate a bean definition --->	<cffunction name="translateBean" access="private" output="false" returntype="void" hint="I translate ColdSpring XML bean definitiions to LightWire config.">		<!---************************************************************************************************ --->		<cfargument name="bean" 		type="any" 		required="true"  hint="The xml bean definition. This is an XML object">		<cfargument name="properties" 	type="struct" 	required="true"  hint="The properties structure">		<!---************************************************************************************************ --->		<cfscript>			var beanStruct = StructNew();			var key = "";			var beanAttributeValue = 0;						// loop over bean tag attributes and create beanStruct keys			For (key in bean.XmlAttributes){				/* Get Attribute Value */				beanAttributeValue = trim(bean.XMLAttributes[key]);				/* Set Values */				if (key eq "factory-bean"){					beanStruct.FactoryBean = beanAttributeValue;				}				if (key eq "factory-method"){					beanStruct.FactoryMethod = beanAttributeValue;				}				if (key eq "singleton"){					beanStruct.Singleton = beanAttributeValue;				}				if (key eq "class"){					beanStruct.FullClassPath = beanAttributeValue;				}				if (key eq "type"){					beanStruct.BeanType = beanAttributeValue;				}				if (key eq "id"){					beanStruct.BeanName = beanAttributeValue;				}				if (key eq "init-method"){					beanStruct.InitMethod = beanAttributeValue;				}							if (key eq "lazy-init"){					beanStruct.Lazy = beanAttributeValue;				}				else{					beanStruct.Lazy = instance.defaultBeanLazyInit;				}			}//end loop over xml attributes						/* Add to non lazy beans? */			if( not beanStruct.Lazy ){				addToNonLazyBeans(beanStruct.beanName);			}						/* Check if Singleton defined, if not, set to default of true */			if( not structKeyExists(beanStruct,"Singleton") ){				beanStruct.Singleton = true;			}						// If not a singleton			if ( not beanStruct.Singleton ){				// if beanStruct contains key FactoryBean, then create transient from factory 				if (structKeyExists(beanStruct,"FactoryBean")){					addTransientFromFactory(argumentCollection=beanStruct);				}				else{					addTransient(argumentCollection=beanStruct);				}			}			else{				// if beanStruct contains key FactoryBean, then create singleton from factory				if (structKeyExists(beanStruct,"FactoryBean")){					addSingletonFromFactory(argumentCollection=beanStruct);				}				else{					addSingleton(argumentCollection=beanStruct);				}			}					// add constructor dependecies and properties			translateBeanChildren(arguments.bean,'constructor-arg',arguments.properties);			// add setter dependecies and properties			translateBeanChildren(arguments.bean,'property',arguments.properties);			// add mixin dependecies and properties			translateBeanChildren(arguments.bean,'mixin',arguments.properties);		</cfscript>	</cffunction>		<!--- Translate bean children --->	<cffunction name="translateBeanChildren" access="private" output="false" returntype="void">		<!---************************************************************************************************ --->		<cfargument name="bean" 		type="any" 		required="true" hint="The xml bean definition object">		<cfargument name="childTagName" type="string" 	required="true" hint="The child tag name to parse">		<cfargument name="properties" 	type="struct" 	required="true" hint="The properties structure">		<!---************************************************************************************************ --->		<cfscript>			var children = "";			var childrenLen = 0;			var thisCast = "";			var entries = "";			var hashMap = "";			var prop = "";			var key = "";			var i = 1;			var j = 1;						/* find all constructor properties and dependencies */			if( structKeyExists(server,"railo") ){				children = xmlSearch(xmlParse(toString(arguments.bean)),"/bean/" & childTagName);			}			else{				children = XMLSearch(arguments.bean,arguments.childTagName);			}			childrenLen = ArrayLen(children);						/* Loop Over Children */				for (i = 1; i lte childrenLen; i = i + 1){				/* child element "value" */				if (structKeyExists(children[i],"value")){					/* prop Replacement */					prop = trim(children[i].value.XmlText);					/* Cast? */					if( structKeyExists(children[i].XMLAttributes,"castTo") ){						thisCast = children[i].xmlAttributes.castTo;						}					else{						thisCast = "";					}					/* Type of Tag Element */					switch (arguments.childTagName){						case 'constructor-arg' :{							addConstructorProperty(beanName=bean.XmlAttributes["id"],PropertyName=children[i].XmlAttributes["name"],PropertyValue=prop,CastTo=thisCast);						};						break;						case 'property' :{							addSetterProperty(beanName=bean.XmlAttributes["id"],PropertyName=children[i].XmlAttributes["name"],PropertyValue=prop,castTo=thisCast);						};						break;						case 'mixin' :{							addMixinProperty(beanName=bean.XmlAttributes["id"],propertyName=children[i].XmlAttributes["name"],propertyValue=prop);						};						break;					};//end of child Tag Name				};// end if tag "value"				// child element "map"				if (structKeyExists(children[i],"map")){					entries = XMLSearch(xmlParse(toString(children[i])),'//map/entry');					hashMap = structNew();					for (j = 1; j lte ArrayLen(entries); j = j + 1){						if (structKeyExists(entries[j],"value")){							hashMap[entries[j].XmlAttributes["key"]] = entries[j].value.XmlText;						} 						else if (structKeyExists(entries[j],"ref")){							hashMap[entries[j].XmlAttributes["key"]] = entries[j].ref.XmlAttributes["bean"];						}					}					switch (arguments.childTagName)					{						case 'constructor-arg' :						{							addConstructorProperty(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],hashMap);						};						break;						case 'property' :						{							addSetterProperty(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],hashMap);						};						break;						case 'mixin' :						{							addMixinProperty(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],hashMap);						};						break;					};				}; //end of tag "map"				// child element "ref"				if (structKeyExists(children[i],"ref")){					switch (arguments.childTagName){						case 'constructor-arg' :{							addConstructorDependency(bean.XmlAttributes["id"],children[i].ref.XmlAttributes["bean"],children[i].XmlAttributes["name"]);						};						break;						case 'property' :{							addSetterDependency(bean.XmlAttributes["id"],children[i].ref.XmlAttributes["bean"],children[i].XmlAttributes["name"]);						};						break;						case 'mixin' :{							addMixinDependency(bean.XmlAttributes["id"],children[i].ref.XmlAttributes["bean"],children[i].XmlAttributes["name"]);						};						break;					};				};				//child element "bean"				if (structKeyExists(children[i],"bean")){					// use recursion to translate Bean					translateBean(children[i].bean,arguments.properties);					/* Do Childs now */					switch (arguments.childTagName)					{						case 'constructor-arg' :						{							addConstructorDependency(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],children[i].bean.XmlAttributes["id"]);						};						break;						case 'property' :						{							addSetterDependency(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],children[i].bean.XmlAttributes["id"]);						};						break;						case 'mixin' :						{							addMixinDependency(bean.XmlAttributes["id"],children[i].XmlAttributes["name"],children[i].bean.XmlAttributes["id"]);						};						break;					};				};			};		</cfscript>	</cffunction><!----------------------------------------- PRIVATE ------------------------------------->				<!--- Get Bean Definition --->	<cffunction name="getBeanDefinition" access="private" returntype="struct" hint="Get a structure with a bean's definitions by default." output="false" >
		<cfscript>		var definition = structnew();				/* Initialize Main Bean Properties */		definition.Singleton = true;		definition.Path = "";		definition.InitMethod = "";		definition.Lazy = instance.defaultBeanLazyInit;		definition.Type = "cfc";				/* Factory Bean Defaults */		definition.FactoryBean = "";		definition.FactoryMethod = "";		definition.isFactoryBean = false;				/* Initialize the dependency structs */		definition.ConstructorDependencyStruct = StructNew();		definition.SetterDependencyStruct = StructNew();		definition.MixinDependencyStruct = StructNew();		/* Init Properties */		definition.MixinProperties = structnew();		definition.SetterProperties = structnew();		definition.ConstructorProperties = structnew();				return definition;		</cfscript>	</cffunction>		<!--- Validate Bean Type --->	<cffunction name="validateBeanType" access="private" returntype="string" hint="Validate an incoming bean type" output="false" >		<!---************************************************************************************************ --->		<cfargument name="BeanType" required="true" type="string" hint="The bean type: cfc, java, webservice">		<!---************************************************************************************************ --->		<cfscript>			/* Check if we have something */			if( len(trim(arguments.BeanType)) ){				if( not reFindnocase("^(cfc|java|webservice)$",arguments.BeanType) ){					getUtil().throwit("Invalid BeanType: #arguments.BeanType#","The only valid beanTypes are cfc,java and webservice","baseConfigObject.invalidBeanType");				}				else{					/* Setup the Type */					return arguments.BeanType;				}			}			/* Return Default */			return "cfc";		</cfscript>	</cffunction>		<!--- Add beans to the non lazy struct --->	<cffunction name="addToNonLazyBeans" access="private" returntype="void" hint="Add to non lazy beans struct" output="false" >		<cfargument name="beanName" required="true" type="any" hint="The bean name to add to the non lazy beans">		<cfset instance.nonLazyBeans[arguments.beanName] = arguments.beanName>	</cffunction>			<!--- Get Bean Name --->	<cffunction name="nameResolution" access="private" returntype="any" hint="Get a bean name via alias or bean name" output="false" >		<!--- ************************************************************* --->		<cfargument name="name" required="true" type="any" hint="Bean name or alias to resolve.">		<!--- ************************************************************* --->		<cfscript>			/* Check if name is in an alias struct. */			if( structKeyExists(instance.aliasStruct,arguments.name) ){				return instance.aliasStruct[arguments.name];			}			/* Else return bean name */			return arguments.name;		</cfscript>	</cffunction>		<!--- getUtil --->
	<cffunction name="getUtil" output="false" access="private" returntype="any" hint="Get the LightWire utility object: coldbox.system.extras.lightwire.util.Utility">
		<cfreturn instance.oUtil>
	</cffunction></cfcomponent>
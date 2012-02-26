/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
The ColdBox validator interface, all inspired by awesome Hyrule Validation Framework by Dan Vega
*/
component accessors="true" implements="coldbox.system.validation.validators.IValidator" singleton{

	property name="name";
	
	RegexValidator function init(){
		name = "Regex";	
		return this;
	}

	/**
	* Will check if an incoming value validates
	* @validationResult.hint The result object of the validation
	* @target.hint The target object to validate on
	* @field.hint The field on the target object to validate on
	* @targetValue.hint The target value to validate
	* @validationData.hint The validation data the validator was created with
	*/
	boolean function validate(required coldbox.system.validation.result.IValidationResult validationResult, required any target, required string field, any targetValue, string validationData){
		
		
		if( isValid("regex", arguments.targetValue, arguments.validationData) ){
			return true;
		}
		
		var args = {message="The '#arguments.field#' value does not match the regular expression: #arguments.validationData#",field=arguments.field};
		validationResult.addError( validationResult.newError(argumentCollection=args) );
		return false;
	}
	
	/**
	* Get the name of the validator
	*/
	string function getName(){
		return name;
	}
	
}
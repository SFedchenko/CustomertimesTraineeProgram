public with sharing class Utils {
    
    public List<Schema.FieldSetMember> getFieldSetFields(String objectName, String fieldSetName) {
    	return ( (SObject)Type.forName(objectName).newInstance() )
				.getSObjectType()
				.getDescribe()
				.fieldSets
				.getMap()
				.get(fieldSetName)
				.getFields()
		;
	}

	public Schema.DescribeFieldResult getField(String objectName, String fieldName) {
		return ( (SObject)Type.forName(objectName).newInstance() )
				.getSObjectType()
				.getDescribe()
				.fields
				.getMap()
				.get(fieldName)
				.getDescribe()
		;
	}
}
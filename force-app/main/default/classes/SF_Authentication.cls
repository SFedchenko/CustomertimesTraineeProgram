public with sharing class SF_Authentication {
    
    public String access_token;
    public String instance_url;
    public String id;
    public String token_type;
    public String issued_at;
    public String signature;

    public SF_Authentication parse(String json) {
        return (SF_Authentication) System.JSON.deserialize(json, SF_Authentication.class);
    }
}
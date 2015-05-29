

Parse.Cloud.beforeSave("Activity", function(request, response) {
	    var Activity = Parse.Object.extend("Activity");
	    // Find every Profile with same entityID
	    var query = new Parse.Query(Activity);
	    query.equalTo("fromProfile", request.object.get("fromProfile"));
	    query.equalTo("toProfile", request.object.get("toProfile"));
		
	query.find().then(function(results) {
		if (results.length > 0)
		{
	  		response.error('duplicate activity prevented');
		}
		else
		{
	  		response.success();			
		}
	});
});

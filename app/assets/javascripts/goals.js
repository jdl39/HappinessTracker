function updateActivityName(newName) {
	$('#goalHeader').text("Set goal for " + newName)
	$('#hiddenActivityNameField').val(newName)
}

function updateMeasurementNames(newNames) {
	console.log(("measurementTypeSelect"))
	$("#measurementTypeSelect").html("")
	for (num in newNames) {
		$("#measurementTypeSelect").append('<option value="' + newNames[num] + '">' + newNames[num] + '</option>')
	}
}

measurementValuePrev = "0"
$(".numberValueField").on('change keyup paste', function(e) {
	var str = this.value
	if (isNaN(str)) {
		str = measurementValuePrev
		this.value = str
	}
	measurementValuePrev = str
})
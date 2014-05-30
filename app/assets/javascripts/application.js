// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/themes/gray


function toggleCreateAccountForm() {
	var loginForm = document.getElementById("login-form");
	loginForm.style.display = "none";
	var createForm = document.getElementById("create-account-form");
	createForm.style.display = "block";
}

function toggleLoginForm() {
	var loginForm = document.getElementById("login-form");
	loginForm.style.display = "block";
	var createForm = document.getElementById("create-account-form");
	createForm.style.display = "none";
}

function togglePageLayout() {
   var body = $("body");
   var wrapper = $(".wrapper");
   var desiredColor = happiness_status ? '#ff9933' : '#5f9ea0';
   body.css("background-color", desiredColor);
   var desiredWrapperColor = happiness_status ? '#cc6600' : '#335556';
   wrapper.css("border-top", "solid 5px " + desiredWrapperColor); 
}

function toggleHeaderLayout() { 
  console.log("Toggle header layout called.")
			    var desiredColor = happiness_status ? '#ff9933' : '#5f9ea0';
		    $("h2").css("color", desiredColor);
			    $("h1").css("color", desiredColor);
				    $("hr").css("background-color", desiredColor);
}

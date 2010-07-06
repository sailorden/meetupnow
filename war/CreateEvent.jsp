<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.Topic" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>
<%@ page import="org.json.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Meetup Now</title>
	<link rel="stylesheet" href="css/reset.css" type="text/css" />
	<link rel="stylesheet" href="css/meetupnow.css" type="text/css" />
	<link rel="stylesheet" href="/css/ui-lightness/jquery-ui-1.8.2.css" type="text/css" />
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jquery-ui.min.js"></script>
	<script type="text/javascript">
	
	$(function() {
		verifyAddress();
		var now = new Date();
		document.getElementById('month').value = now.getMonth()+1;
		document.getElementById('day').value = now.getDate();
		document.getElementById('localTimeZone').value = now.getTimezoneOffset()/60;
	});
	
	/* jQuery UI */
	
	var sdate = new Date();

	
	if ( sdate.getHours() > 12 ) {
		shour = sdate.getHours() - 12;
	} else {
		shour = sdate.getHours();
	}
	
	if ( ( sdate.getMinutes() / 60 ) <= .25 ) {
		sminute = 15;
	} else if ( sdate.getMinutes() / 60 <= .5 ) {
		sminute = 30;
	} else if ( sdate.getMinutes() / 60 <= .75) {
		sminute = 45;
	} else if ( sdate.getMinutes() / 60 <= 1) {
		sminute = 00
		shour += 1;
	}
	

	

		
		var sdate = new Date();

		if ( sdate.getHours() > 12 ) {
			shour = sdate.getHours() - 12;
		} else {
			shour = sdate.getHours();
		}

		if ( ( sdate.getMinutes() / 60 ) <= .25 ) {
			sminute = .25;
		} else if ( sdate.getMinutes() / 60 <= .5 ) {
			sminute = .5;
		} else if ( sdate.getMinutes() / 60 <= .75) {
			sminute = .75;
		} else if ( sdate.getMinutes() / 60 <= 1) {
			sminute = 0;
			shour += 1;
		}
	
	// Today/Tommorrow button
	$(function() {
			$("#radio_when").buttonset();
	});
	
	// Date/Time picker slider
	$(function() {
		
		var sdate = new Date();
		var time = new Date();
		// Calc min decimal time
		shour = sdate.getHours();

		if ( ( sdate.getMinutes() / 60 ) <= .25 ) {
			sminute = .25;
		} else if ( ( sdate.getMinutes() / 60 ) <= .5 ) {
			sminute = .5;
		} else if ( ( sdate.getMinutes() / 60 ) <= .75) {
			sminute = .75;
		} else if ( ( sdate.getMinutes() / 60 ) <= 1) {
			sminute = 0;
			shour += 1;
		}
		
		minTimeValue = sdate.getTime();
		maxTimeValue = minTimeValue + 172800000;
		
			$("#slider").slider({
				value: minTimeValue,
				min: minTimeValue,
				max: maxTimeValue,
				step: 900000,
				slide: function(event, ui) {
					time.setTime(ui.value);
					$("#amount").val(time.getHours() + ":" + time.getMinutes());
					document.getElementById('month').value = time.getMonth()+1;
					document.getElementById('day').value = time.getDate();
					document.getElementById('localTimeZone').value = time.getTimezoneOffset()/60;

					document.getElementById('year').value = time.getFullYear();
					document.getElementById('hour').value = time.getHours();
					document.getElementById('minute').value = time.getMinutes();

				}
			});
			$("#amount").val('$' + $("#slider").slider("value"));
	});

	var addressCheck = false;

	function verifySubmission() {

		var now = new Date();

		var now_hour = now.getHours();
		var now_ampm = "am";
		if (now_hour > 12) {
			now_hour = now_hour - 12;
			now_ampm = "pm";
		}
		if (now_hour == 0) {
			now_hour = 12;
		}

		var canSubmit = true;
		var message = "";

		if (document.getElementById('topic').value == "") {
			message = message + "Please select a topic for your event\n";
			canSubmit = false;
		}

		if (document.getElementById('title').value == "") {
			message = message + "Please enter a title for your event\n";
			canSubmit = false;
		}
		if (document.getElementById('venue').value == "") {
			message = message + "Please pick a venue\n";
			canSubmit = false;
		}
		if ((document.getElementById('hour').value == "")||(document.getElementById('minute').value == "")) {
			message = message + "Please pick a time\n";
			canSubmit = false;
		}

		if (document.getElementById('desc').value == "") {
			message = message + "Please enter a description\n";
			canSubmit = false;
		}

		if (document.getElementById('address').value == "") {
			message = message + "Please enter an address\n";
			canSubmit = false;
		}

		if (!addressCheck) {
			message = message + "Enter a valid Address";
			canSubmit = false;
		}
	
		if((parseInt(document.getElementById('year').value) - 1900) < now.getYear()) {
			message = message + "Please enter a date in the future\n";
			canSubmit = false;
		} else if ((parseInt(document.getElementById('year').value) - 1900) == now.getYear()){
			if ((parseInt(document.getElementById('month').value) - 1) < now.getMonth()) {
				message = message + "Please enter a date in the future\n";
				canSubmit = false;
			} else if ((parseInt(document.getElementById('month').value) - 1) == now.getMonth()){
				if (parseInt(document.getElementById('day').value) < now.getDate()) {
					message = message + "Please enter a date in the future\n";
					canSubmit = false;
				} else if (parseInt(document.getElementById('day').value) == now.getDate()){
					if (document.getElementById('ampm').value == "am") {
						if (now_ampm == "pm") {
							message = message + "Please enter a time in the future\n";
							canSubmit = false;
						}
						else if (parseInt(document.getElementById('hour').value) < now_hour) {
							message = message + "Please enter a time in the future\n";
							canSubmit = false;
						} else if (parseInt(document.getElementById('hour').value) == now_hour) {
							if (parseInt(document.getElementById('minute').value) < now.getMinutes() ) {
								message = message + "Please enter a time in the future\n"
								canSubmit = false;
							}
						}
					} else  { //pm
						if (now_ampm == "pm") {
							if (parseInt(document.getElementById('hour').value) < now_hour) {
								message = message + "Please enter a time in the future\n";
								canSubmit = false;
							} else if (parseInt(document.getElementById('hour').value) == now_hour) {
								if (parseInt(document.getElementById('minute').value) < now.getMinutes() ) {
									message = message + "Please enter a time in the future\n"
									canSubmit = false;
							}
						}
							
						}
					}
				}
			}
		}

		if (canSubmit) {
			return true;
		} else {
			alert(message);
			return false;
		}
	}

	function verifyAddress() {
		var add = $('#address');
		var out = $('#out');
		var geocoder = new google.maps.Geocoder();
		var lat;
		var lon;
		var address;

		if(geocoder){
			geocoder.geocode( { 'address': add.val()}, function(results, status) {
				if (status == google.maps.GeocoderStatus.OK) {
					var ad_out = "";
					var city_out = "";
					var state_out = "";
					var country_out = "";
					var zip_out = "";
					document.getElementById('lat').value = results[0].geometry.location.lat();
					document.getElementById('lon').value = results[0].geometry.location.lng();
					address = results[0].formatted_address;
					
					var k;
					var t;
					for (k = 0; k < results[0].address_components.length; k++) {
						var temp = results[0].address_components[k];
						for (t = 0; t < temp.types.length; t++) {
							if (temp.types[t] == "street_number") {
								ad_out = ad_out + temp.long_name+" ";	
							}
							if (temp.types[t] == "route") {
								ad_out = ad_out + temp.long_name+" ";
							}
							if (temp.types[t] == "subpremise") {
								ad_out = ad_out +"#"+ temp.long_name+", ";
							}
							if (temp.types[t] == "locality") {
								city_out = temp.long_name;
							}
							if (temp.types[t] == "administrative_area_level_1") {
								state_out = temp.long_name;
							}
							if (temp.types[t] == "country") {
								country_out = temp.long_name;
							}
							if (temp.types[t] == "postal_code") {
								zip_out = temp.long_name;
							}
						}
					}

					document.getElementById('ad').value = ad_out;
					document.getElementById('city').value = city_out;
					document.getElementById('state').value = state_out;
					document.getElementById('country').value = country_out;
					document.getElementById('zip').value = zip_out;
							
					out.empty();
					out.append("VALID");
					addressCheck = true;
				} else {
					out.empty();
					out.append("NOT VALID");
					addressCheck = false;
				}
				
			});
		}
	}
</script>
</head>
<body>
	
<%@ include file="jsp/cookie.jsp" %>
<%@ include file="jsp/declares.jsp" %>

<div id="wrap">
	
	<%@ include file="jsp/header.jsp" %>
	
	<div id="main">
		<div id="contentLeft">
			<div id="contentLeftBody">
				<form id="form_createEvent" name="f" action="/EventCreate" onSubmit="return verifySubmission()" method="get">
					<span class="title">Create An Event</span>
				
				<%
					Query TopicQuery = pm.newQuery(Topic.class);
					TopicQuery.setFilter("id != 0");
					TopicQuery.declareParameters("String reqTokenParam");	//Setup Query

					List<Topic> topics = new ArrayList<Topic>();
					try {
						topics = (List<Topic>) pm.detachCopyAll((List<Topic>) TopicQuery.execute(key));
					} finally {

					}
				%>
				
					<frameset>
					<legend>Title</legend>
					<ul>
					<li>
						<label for="title" class="hidden">Title</label>
						<input type="text" value="" name="name" id="title">
					</li>
					<li>
						<label for="topic" class="hidden">Select Topic</label> 
						<select id="topic" name="topic">
							<option value="">-Select-</option>
							
				<%
						for (int i = 0; i < topics.size(); i++) {
				%>
				
							<option value="<%=topics.get(i).getId()%>"><%=topics.get(i).getName()%></option>
				<%
						}
				%>
			
						</select>
					</li>
					</ul>
					</frameset>
					
					<frameset>
					<legend>When</legend>
					<ul id="radio_when">
						<li>
							<input type="radio" id="radio1" name="radio" checked="checked"><label for="radio1">Today</label>
							<input type="radio" id="radio2" name="radio"><label for="radio2">Tomorrow</label>
						</li>
						<li>
							<label for="amount">Donation amount ($50 increments):</label>
							<input type="text" id="amount" style="border:0; color:#f6931f; font-weight:bold;" />

							<div id="slider"></div>
						</li>
					</ul>
					</frameset>
					
	<br><br><br><br><br>
	<span class="goLeft"><span class="heading"> When? </span></span>
	<span class="goRight">		

		<br>
	</span>
	<br><br><br><br><br>
	<span class="goLeft"><span class="heading"> Where? </span></span>
	<span class="goRight">
		Venue<br>
		<input type="text" name="venue" id="venue"/><br>
		Address or Zip Code<br>
		<input type="text" id="address" onChange="verifyAddress()" onKeyUp="verifyAddress()"/> <br>
		<div id="out">NOT VALID</div>
	</span>
	<br><br><br><br><br><br><br><br><br>
	<span class="goCenter">
		<span class="heading"> Description: </span>
		<span class="heading"> <textarea name="desc" id="desc" cols="60" rows="4"></textarea></span> <br>
	</span>
	<br><br><br>
	<input type="hidden" name="month" id="month" />
	<input type="hidden" name="day" id="day" />
	<input type="hidden" name="year" id="year" />
	<input type="hidden" name="hour" id="hour" />
	<input type="hidden" name="minute" id="minute" />
	<input type="hidden" name="ampm" id="ampm" />
	<input type="hidden" name="localTimeZone" id="localTimeZone" />
	<input type="hidden" name="lat" value="NA" id="lat" />
	<input type="hidden" name="lon" value="NA" id="lon" />
	<input type="hidden" name="zip" value="NA" id="zip" />
	<input type="hidden" name="ad" value="NA" id="ad" />
	<input type="hidden" name="country" value="NA" id="country" />
	<input type="hidden" name="city" value="NA" id="city" />
	<input type="hidden" name="state" value="NA" id="state" />
	<input type="hidden" name="callback" value="congrats.jsp" />
	<input type="submit" id="exe" value="Create" />
</span>
</form>
			</div> <!-- end #contentLeftBody -->
		</div> <!-- end #contentLeft -->
	</div> <!-- end #main -->
</div> <!-- end #wrap -->

<%@ include file="jsp/footer.jsp" %>

</body>
</html>

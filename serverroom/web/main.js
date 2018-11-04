var client = undefined;
var espID = '';
var pinSwitch = '';

function main(){
	client = new Paho.MQTT.Client('10.20.1.100', 9001, 'web-client');
	client.onConnectionLost = onConnectionLost;
	client.onMessageArrived = onMessageArrived;
	client.connect({onSuccess:onConnect});
}

function createUI(){
	Ext.create('Ext.panel.Panel', {
		bodyPadding : 5,
		width : 300,
		title : 'light controller',
		renderTo : Ext.getBody(),
		items : [
			{
				xtype : 'button', id: 'switch_button', text: '...', width : 100, height : 24,
				handler: function(btn){
					var message = new Paho.MQTT.Message(btn.nextState);
					message.destinationName = '/ESP' + espID + '/CMD/GPIO/' + pinSwitch;
					client.send(message);
			}}
		]
	});
}

///ESP10211775/STAT

function parseParams(mqttMessage){
	console.log("parse: " + mqttMessage.destinationName + " " + mqttMessage.payloadString);
	var conf = Ext.decode(mqttMessage.payloadString);
	pinSwitch = conf.relayPinNum;
	var state = conf.State;

	var myRegexp = /(?:\d+)/;
	var match = myRegexp.exec(mqttMessage.destinationName);
	if (match != undefined){
		espID = match[0];
	}
	console.log("esp id:" + espID); 

	var btn = Ext.getCmp('switch_button');
	if (btn != undefined){
		btn.nextState = state == 0 ? "1" : "0";
		btn.setText(state == 0 ? "On" : "Off");
		btn.setIconCls(state == 0 ? 'state_off' : 'state_on');
	}
}

function onConnect() {
	console.log("onConnect");
	client.subscribe("/#");
	createUI();
   }
   
   function onConnectionLost(responseObject) {
	//if (responseObject.errorCode !== 0) {
	 console.log("onConnectionLost:" + responseObject.errorMessage);
	//}
   }
   
   function onMessageArrived(message) {
	console.log("onMessageArrived: " + message.destinationName + " : " + message.payloadString);
	if (message.destinationName.match(/\/ESP\d+\/STAT/)){
		parseParams(message);
	}
   }
   

Ext.onReady(function(){
	main();
});
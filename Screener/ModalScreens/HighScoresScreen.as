package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.net.*;
	import Game.*;
	import Screener.*;
	
	public final class HighScoresScreen extends BaseScreen {
		private const numScoresToShow:int = 15;

		private var scoreBoxes:Array = [];
		
		private var allTimeScores:Array;
		private var todayScores:Array;
		private var phoneScores:Array;
		
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttBack];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			for (var i:int = 0; i < numScoresToShow; i++) {
				var scoreBox:MovieClip = new mcScoreBox ();
				scoreBoxes.push (scoreBox);
				scoreBox.x = 145;
				scoreBox.y = 65 + i * 22;
				addChild (scoreBox);
			}
			
			txtAllTime.alpha = 0.5;
			txtToday.alpha = 0.5;
			txtPhone.alpha = 0.5;
			
			GetScores (1);
			
			var date:Date = new Date ();
			var hourOffset:int = date.timezoneOffset / 60;
			var hour:int = date.hours - date.hoursUTC;
			hour = (hour < 0) ? hour + 24 : hour;
			var hourString:String;
			
			if (hour == 0) {
				hourString = "12 AM";
			} else if (hour < 12) {
				hourString = hour.toString () + " AM";
			} else if (hour == 12) {
				hourString = "12 PM";
			} else {
				hourString = (hour - 12).toString () + " PM";
			}
			
			txtTimezone.text = "Since " + hourString + " local";
			txtTimezone.visible = false;
		}
		
		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OVER, onRollOver);
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OUT, onRollOut);
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function GetScores (gameMode:int) {
			allTimeBar.visible = true;
			todayBar.visible = true;
			phoneBar.visible = true;
			
			txtAllTime.alpha = 0.5;
			txtToday.alpha = 0.5;
			txtPhone.alpha = 0.5;
			
			Main.highScores.addEventListener (HighScoreEvent.AllTimeReceived, onAllTimeReceived, false, 0, true);
			Main.highScores.addEventListener (HighScoreEvent.TodayReceived, onTodayReceived, false, 0, true);
			Main.highScores.addEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived, false, 0, true);
			Main.highScores.Refresh ();
		}

		private function onAllTimeReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.AllTimeReceived, onAllTimeReceived);
			
			allTimeBar.visible = false;
			
			allTimeScores = e.data;
			
			txtAllTime.alpha = 1;
			txtAllTime.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtAllTime.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}
		
		private function onTodayReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.TodayReceived, onTodayReceived);
			
			todayBar.visible = false;
			
			todayScores = e.data;
			
			txtToday.alpha = 1;
			txtToday.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtToday.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}
		
		private function onPhoneReceived (e:HighScoreEvent) {
			Main.highScores.removeEventListener (HighScoreEvent.PhoneReceived, onPhoneReceived);

			phoneBar.visible = false;
			
			phoneScores = e.data;
			
			txtPhone.alpha = 1;
			txtPhone.addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			txtPhone.dispatchEvent (new MouseEvent (MouseEvent.MOUSE_DOWN));
		}

		private function ShowScores (scoreArray:Array) {
			txtAllTime.textColor = 0xFFFFFF;
			txtToday.textColor = 0xFFFFFF;
			txtPhone.textColor = 0xFFFFFF;
			
			if (scoreArray == allTimeScores) {
				txtAllTime.textColor = 0xFFFF00;
				txtTimezone.visible = false;
			} else if (scoreArray == todayScores) {
				txtToday.textColor = 0xFFFF00;
				txtTimezone.visible = true;
			} else if (scoreArray == phoneScores) {
				txtPhone.textColor = 0xFFFF00;
				txtTimezone.visible = false;
			}
			
			for (var i:int = 0; i < scoreBoxes.length; i++) {
				if (i < scoreArray.length) {
					scoreBoxes [i].txtName.text = scoreArray [i].name;
					scoreBoxes [i].txtScore.text = scoreArray [i].score;
				} else {
					scoreBoxes [i].txtName.text = "";
					scoreBoxes [i].txtScore.text = "";
				}
			}
			
			if (scoreArray.length == 0) {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.CENTER;
				scoreBoxes [0].txtName.text = "No scores in this category";
				scoreBoxes [0].txtName.setTextFormat (tf);
			} else {
				var tf:TextFormat = scoreBoxes [0].txtName.getTextFormat ();
				tf.align = TextFormatAlign.LEFT;
				scoreBoxes [0].txtName.setTextFormat (tf);
			}
		}
		
		private function onRollOver (e:MouseEvent) {
			if (e.currentTarget is SimpleButton) {
				var btt:SimpleButton = SimpleButton (e.currentTarget);
				var glow:GlowFilter = btt.filters [0];
				glow.blurX = 32;
				glow.blurY = glow.blurX;
				btt.filters = [glow];
			}
		}
		
		private function onRollOut (e:MouseEvent) {
			if (e.currentTarget is SimpleButton) {
				var btt:SimpleButton = SimpleButton (e.currentTarget);
				var glow:GlowFilter = btt.filters [0];
				glow.blurX = 8;
				glow.blurY = glow.blurX;
				btt.filters = [glow];
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == txtAllTime) {
				ShowScores (allTimeScores);
			} else if (e.currentTarget == txtToday) {
				ShowScores (todayScores);
			} else if (e.currentTarget == txtPhone) {
				ShowScores (phoneScores);
			} else if (e.currentTarget == bttBack) {
				screenMgr.RemoveModalScreen ("");
			}
		}
	}
}
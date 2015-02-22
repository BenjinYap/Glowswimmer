package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import Screener.*;
	import Game.*;
	
	public final class MenuScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttPlay, bttCredits, sponsorLogo];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
		}

		public override function PrepareToDie () {
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OVER, onRollOver);
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OUT, onRollOut);
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onRollOver (e:MouseEvent) {
			if (e.currentTarget is SimpleButton && e.currentTarget != sponsorLogo) {
				var btt:SimpleButton = SimpleButton (e.currentTarget);
				var glow:GlowFilter = btt.filters [0];
				glow.blurX = 32;
				glow.blurY = glow.blurX;
				btt.filters = [glow];
			}
		}
		
		private function onRollOut (e:MouseEvent) {
			if (e.currentTarget is SimpleButton && e.currentTarget != sponsorLogo) {
				var btt:SimpleButton = SimpleButton (e.currentTarget);
				var glow:GlowFilter = btt.filters [0];
				glow.blurX = 8;
				glow.blurY = glow.blurX;
				btt.filters = [glow];
			}
		}
		
		private function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttPlay) {
				screenMgr.NewBigScreen (ScreenType.Game);
			} else if (e.currentTarget == bttCredits) {
				screenMgr.AddModalScreen (ScreenType.Credits);
			} else if (e.currentTarget == sponsorLogo) {
                navigateToURL (new URLRequest ("http://www.myultimategames.com"));
            }
		}
	}
}

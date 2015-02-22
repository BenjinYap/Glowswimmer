package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.filters.*;
	import Screener.*;
	import Game.*;
	
	public final class CreditsScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttBack, bttLogo];
			
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
            if (e.currentTarget != bttLogo) {
			    var btt:SimpleButton = SimpleButton (e.currentTarget);
			    var glow:GlowFilter = btt.filters [0];
			    glow.blurX = 32;
			    glow.blurY = glow.blurX;
			    btt.filters = [glow];
            }
		}
		
		private function onRollOut (e:MouseEvent) {
            if (e.currentTarget != bttLogo) {
			    var btt:SimpleButton = SimpleButton (e.currentTarget);
			    var glow:GlowFilter = btt.filters [0];
			    glow.blurX = 8;
			    glow.blurY = glow.blurX;
			    btt.filters = [glow];
            }
		}
		
		public function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttBack) {
				screenMgr.RemoveModalScreen ("");
			} else if (e.currentTarget == bttLogo) {
				navigateToURL (new URLRequest ("http://www.benjyap.99k.org"));
			}
		}
	}
}

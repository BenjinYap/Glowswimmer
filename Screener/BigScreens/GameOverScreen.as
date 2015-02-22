package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.text.*;
	import flash.net.*;
	import flash.xml.*;
	import Game.*;
    import mochi.as3.*;
	import Screener.*;
	
	public final class GameOverScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [sponsorLogo, bttMenu, bttPlayAgain];
			
            txtScore.text = GameData.score.toString ();

			for (var i = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			txtGems.text = GameData.numGemsGot.toString () + "/" + GameData.numGems.toString () + " (" + Math.round (GameData.numGemsGot / GameData.numGems * 100).toString () + "%)";
			txtCoins.text = GameData.numCoinsGot.toString () + "/" + GameData.numCoins.toString () + " (" + Math.round (GameData.numCoinsGot / GameData.numCoins * 100).toString () + "%)";
		
            if (GameData.numGems == 0) {
                txtGems.text = "0/0";
            }

            if (GameData.numCoins == 0) {
                txtCoins.text = "0/0";
            }

            var o:Object = { n: [0, 2, 10, 8, 4, 14, 7, 13, 13, 6, 6, 8, 12, 3, 15, 1], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
            var boardID:String = o.f(0,"");
            MochiScores.showLeaderboard({boardID: "f1c2c728ed9c1919", score: GameData.score, onClose:function () {scoreCover.visible = false;} });	
        }
		
		public override function PrepareToDie () {
			for (var i = 0; i < mouseDownTargets.length; i++) {
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
			if (e.currentTarget == bttMenu) {
				screenMgr.NewBigScreen (ScreenType.Menu);
			} else if (e.currentTarget == bttPlayAgain) {
				screenMgr.NewBigScreen (ScreenType.Game);
			} else if (e.currentTarget == sponsorLogo) {
                navigateToURL (new URLRequest ("http://www.myultimategames.com"));
            }
		}
	}
}

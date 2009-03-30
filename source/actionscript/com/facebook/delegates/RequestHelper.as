package com.facebook.delegates {
	import com.adobe.crypto.MD5;
	import com.facebook.facebook_internal;
	import com.facebook.net.FacebookCall;
	import com.facebook.session.DesktopSession;
	import com.facebook.session.IFacebookSession;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	use namespace facebook_internal;
	
	public class RequestHelper {
		
		protected static var callID:int = 0;
		
		public function RequestHelper() { }
		
		/**
		 * 
		 * 
		 */
		public static function formatRequest(call:FacebookCall):void {
			var session:IFacebookSession = call.session;
			
			call.facebook_internal::setRequestArgument("v", session.api_version);
			//call.setRequestArgument("format", "XML");
			
			if (session.api_key != null) {
				call.facebook_internal::setRequestArgument("api_key", session.api_key);
			}
			
			if (session.session_key != null) {
				call.facebook_internal::setRequestArgument("session_key", session.session_key);
			}
			
			var call_id:String = ( new Date().valueOf() ).toString() + ( callID++ ).toString();
			call.facebook_internal::setRequestArgument( 'call_id', call_id );
			call.facebook_internal::setRequestArgument( 'method', call.method );
			
			//Create signature hash. NOTE: You cannot use setRequestArgument() after calling this.
			call.facebook_internal::setRequestArgument("sig", formatSig(call));
		}
		
		/**
		 * Construct the signature as described by Facebook api documentation.
		 */
		public static function formatSig(call:FacebookCall):String {
			var session:IFacebookSession = call.session;
			
			var a:Array = [];
			
			for (var p:String in call.args) {
				var arg:* = call.args[p];
				if (p !== 'sig' && !(arg is ByteArray) && !(arg is FileReference) && !(arg is BitmapData) && !(arg is Bitmap)) {
					a.push( p + '=' + arg.toString() );
				}
			}
			
			a.sort();
			
			var s:String = a.join('');
			if (session.secret != null) {
				s += session.secret;
			}
			
			return MD5.hash(s);
		}	

	}
}
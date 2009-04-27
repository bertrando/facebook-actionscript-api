/*
This method removes a comment from a story.

*/
package com.facebook.commands.stream {
	
	import com.facebook.facebook_internal;
	import com.facebook.net.FacebookCall;
	
	use namespace facebook_internal;
	
	public class RemoveLike extends FacebookCall {
		
		public static const METHOD_NAME:String = 'stream.removeLike';
		public static const SCHEMA:Array = ['post_id', 'uid'];
		
		public var post_id:String;
		public var uid:String;
		
		public function RemoveLike(post_id:String = null, uid:String = null) {
			super(METHOD_NAME);
			
			this.post_id = post_id;
			this.uid = uid;
		}
		
		override facebook_internal function initialize():void {
			applySchema(SCHEMA, post_id, uid);
			super.facebook_internal::initialize();
		}
		
	}
}
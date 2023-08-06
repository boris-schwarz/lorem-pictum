component accessors='false' output='false' hint='Application.cfc' {


	/**
   * @hint Fired on every request to the application
   * @targetPage Requested page
   */
	public void function onRequest() {
		local.loremPictum = new LoremPictum();
		local.attributes = listToArray(cgi.path_info, '/');

		for (var index = 1; index <= arrayLen(local.attributes); index++) {
			switch (index) {
				case 1:
					local.loremPictum.setWidth(local.attributes[index]);
					break;
				case 2:
					local.loremPictum.setHeight(local.attributes[index]);
					break;
				case 3:
					local.loremPictum.setCanvasColor(local.attributes[index]);
					break;
				case 4:
					local.loremPictum.setText(local.attributes[index]);
					break;
				case 5:
					local.loremPictum.setTextColor(local.attributes[index]);
					break;
				default:
					break;
			}
		}

		local.loremPictum.inline();
	}


}
component accessors='false' displayname='LoremPictum' output='false' hint='' {

  variables.defaults = {
    'width': 320,
    'height': 320,
    'canvasColor': 'teal',
    'text': '',
    'textColor': 'fff'
  };


  /**
   * @hint initialize component
   * @width The width of the image in pixels
   * @height The height of the image in pixels
   * @canvasColor The background color of the image in a hexadecimal format
   * @text The text to be displayed in the image
   * @textColor The color of the text on the image in a hexadecimal format
   * @return this
   */
  public component function init(numeric width=variables.defaults.width, numeric height=variables.defaults.height, string canvasColor=variables.defaults.canvasColor, string text=variables.defaults.text, string textColor=variables.defaults.textColor) {
    setWidth(arguments.width);
    setHeight(arguments.height);
    setCanvasColor(arguments.canvasColor);
    setText(arguments.text);
    setTextColor(arguments.textColor);

    return this;
  }


  /**
   * @hint Sets the width of the image
   * @width The width of the image in pixels
   * @return this
   */
  public component function setWidth(required numeric width) {
    if (NOT isNumeric(arguments.width)) {
      arguments.width = variables.defaults.width;
    } else {
      arguments.width = round(arguments.width);
    }

    if (arguments.width < 1) {
      arguments.width = variables.defaults.width;
    }

    variables.width = arguments.width;

    return this;
  }


  /**
   * @hint Sets the height of the image
   * @height The height of the image in pixels
   * @return this
   */
  public component function setHeight(required numeric height) {
    if (NOT isNumeric(arguments.height)) {
      arguments.height = variables.defaults.height;
    } else {
      arguments.height = round(arguments.height);
    }

    if (arguments.height < 1) {
      arguments.height = variables.defaults.height;
    }

    variables.height = arguments.height;

    return this;
  }


  /**
   * @hint Sets the canvasColor of the image
   * @canvasColor The canvasColor of the image in a hexadecimal format
   * @return this
   */
  public component function setCanvasColor(required string canvasColor) {
    // TODO: Check if the color is valid
    variables.canvasColor = arguments.canvasColor;

    return this;
  }


  /**
   * @hint Sets the text of the image
   * @text The text that will be displayed on the image
   * @return this
   */
  public component function setText(required string text) {
    variables.text = trim(arguments.text);

    return this;
  }


  /**
   * @hint Sets the textColor of the image
   * @textColor The textColor of the image in a hexadecimal format
   * @return this
   */
  public component function setTextColor(required string textColor) {
    // TODO: Check if the color is valid
    variables.textColor = arguments.textColor;

    return this;
  }


  /**
   * @hint Writes the image to the browser
   * @return this
   */
  public object function writeToBrowser() {
    local.image = createImage();
    cfimage(action="writeToBrowser", source=local.image);

    return this;
  }


  /**
   * @hint Forces the browser to download the image
   * @return this
   */
  public object function download() {
    local.image = createImage();
    deliverImage(contentDisposition='download', image=local.image);

    return this;
  }


  /**
   * @hint Forces the browser to download the image
   * @return this
   */
  public object function inline() {
    local.image = createImage();
    deliverImage(contentDisposition='inline', image=local.image);

    return this;
  }


  /**
   * @hint Creates the image object
   * @return this
   */
  private struct function createImage() {
    // create image object
    try {
      local.image = ImageNew(source='', width=variables.width, height=variables.height, imageType='rgb', canvasColor=variables.canvasColor);
    } catch(any e) {
      variables.canvasColor = variables.defaults.canvasColor;
      local.image = ImageNew(source='', width=variables.width, height=variables.height, imageType='rgb', canvasColor=variables.canvasColor);
    }

    // draw text
    if (len(variables.text)) {
      // set font family
      local.fontFamily = 'Arial';

      // set font size in relation of the width of the image
      local.fontSize = variables.width / len(variables.text) * 1.2;
      if (local.fontSize > variables.height * 1.4) {
        local.fontSize = variables.height * 1.2;
      }

      // calculate text dimensions, so we can center the text
      local.bufferedImage = ImageGetBufferedImage(local.image);
      local.fontRenderContext = local.bufferedImage.getGraphics().getFontRenderContext();
      local.font = createObject('java', 'java.awt.Font');
      local.textFont = local.font.init(local.fontFamily, local.font.PLAIN, javacast('int', local.fontSize));
      local.textLayout = createObject('java', 'java.awt.font.TextLayout').init(variables.text, local.textFont, local.fontRenderContext);
      local.textBounds = local.textLayout.getBounds();

      // calculate x and y position
      local.xPosition = variables.width / 2 - local.textBounds.getWidth() / 2;
      local.yPosition = variables.height / 2 + local.textBounds.getHeight() / 2;

      // set text color
      try {
        ImageSetDrawingColor(local.image, variables.textColor);
      } catch(any e) {
        variables.textColor = variables.defaults.textColor;
        ImageSetDrawingColor(local.image, variables.textColor);
      }

      // draw text
      ImageDrawText(local.image, variables.text, local.xPosition, local.yPosition, {
        'font' = local.fontFamily,
        'size' = local.fontSize
      });
    }

    return local.image;
  }


  /**
   * @hint
   * @contentDisposition Specifies whether the image should be downloaded or displayed inline
   * @image The image object
   * @return this
   */
  private void function deliverImage(string contentDisposition='inline', required struct image) {
    // create unique file name
    local.uuid = createUUID();
    local.fileName = expandPath('/..') & '/' & local.uuid & '.png';

    // check if contentDisposition is valid
    if (NOT listFindNoCase('inline,attachment', arguments.contentDisposition)) {
      arguments.contentDisposition = 'inline';
    }

    // write image to file, deliver it and delete file
    cfimage(action='write', destination=local.fileName, source=arguments.image);
    cfheader(name='content-disposition', value='#arguments.contentDisposition#; filename=lorem-ipsum.png');
    cfcontent(type='image/png', file=local.fileName, reset=true, deletefile=true);
  }


}
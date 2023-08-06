# Lorem Pictum
ColdFusion placeholder image generator

## Arguments
1. Width - The width of the image
2. Height - The height of the image
3. CanvasColor - The background color of your image
    1. Can be a HTML Color Name, e.g. Tomato
    2. Can be a Hex Color Code, e.g. CFCFCF
4. Text - The text you want to display
5. TextColor - The color of the text you want to display
    1. Can be a HTML Color Name, e.g. Tomato
    2. Can be a Hex Color Code, e.g. CFCFCF

## Using with a domain
If you have set up Lorem Pictum under a domain, you can use directly inline:

`<img src="https://lorem-pictum.yourdomain.tld/800/600/cfcfcf/Your Text/black/" alt="Placeholder Image">`


## Using manually
Alternatively, you can create an instance in your ColdFusion code:

`local.loremPictum = new LoremPictum(width=300, height=400, canvasColor="teal", text="404", textColor="white");`

1. You can then either force a download

`local.loremPictum.download();`

2. You can display the image directly in the browser

`local.loremPictum.inline();`

3. Or you can create an <img> tag via ColdFusion

`local.loremPictum.writeToBrowser();`

Lorem Pictum supports method chaining

`new LoremPictum().setWidth(800).setHeight(600).inline();`


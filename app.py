from flask import Flask, render_template

from quapp import quotes

app = Flask(__name__)


@app.route('/')
def index():
    title = 'quapp'
    bg_img_url = 'https://picsum.photos/1920/1080'
    quote, author = quotes.get_random_quote()
    return render_template('index.html.j2', title=title,
                           bg_img_url=bg_img_url,
                           quote=quote, author=author)


if __name__ == '__main__':
    app.run(debug=True)

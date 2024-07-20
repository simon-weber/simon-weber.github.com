serve:
	bundle exec jekyll serve --host=0.0.0.0

# To publish:
#   bundle exec jekyll build --future
#   mv _site ..
#   git co master
#   rsync -arv ../_site/* .
# Then cd to the other repo, rsync from there, and discard the CNAME change.

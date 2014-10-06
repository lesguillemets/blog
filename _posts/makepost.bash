filename="`date "+%Y-%m-%d-"`$1".md
cp -i ./template.md "$filename"
echo "Created $filename"
if [ "$2" == "-g" ] || [ "$2" == "--gvim" ] || [ "$2" == "--gui" ]; then
    gvim $filename
else
    vim $filename
fi

install_dir=/usr/local
orig_dir=$PWD/test

for orig_file in $(find $orig_dir -type f); do
    installed_file="$(echo "$orig_file" | sed -e "s;$orig_dir;$install_dir;g")"
    rm "$installed_file"
done

find $install_dir -type d -empty -exec rm -r "{}" \;

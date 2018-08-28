gcc_dir="/usr/local/Cellar/gcc/8.1.0/bin"
bin_dir="/usr/local/bin"

for file in $(ls $gcc_dir | grep "[-]8"); do
    new_name="$(echo "$file" | sed 's/-8$//g')"

    echo ln -s "$gcc_dir/$file" "$bin_dir/$new_name"
    ln -s "$gcc_dir/$file" "$bin_dir/$new_name"
done


#!/bin/bash
# TODO add the possibility to revert to secondary url
# if either github is offline or the current latest is broken for some
# reason
#
#

echo "downloading Helix..."
curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
  | jq -r '.assets[] | select(.name | test("x86_64-linux.tar.xz")) | .browser_download_url' > helix_download_url.txt

if [[ ! -s helix_download_url.txt ]]; then
  echo "no download found!"
  exit 1
fi


echo "downloading latest helix package..."
curl -LO $(cat helix_download_url.txt)

echo "extracting..."
tar -xf helix*.tar.xz

# TODO make it work with rootless docker 
echo "installing in /usr/local/bin/"
mv helix*/hx /usr/local/bin/

echo "copying config..."
mkdir -p ~/.config/helix/
mv helix*/runtime ~/.config/helix/

rm ./helix* -rf 

echo '
theme="bogster"
' > ~/.config/helix/config.toml
echo -e "bogster theme set\n"

echo ' 
[lsp]
command = "clangd"
root_file = "CMakeLists.txt"
filetypes = ["c", "cpp"]' > ~/.config/helix/clangd.toml
echo -e "lsp for c/cpp set\n\n"

echo "setting up clang format style in ~"
cp ./.clang-format ~/

echo "config complete!"

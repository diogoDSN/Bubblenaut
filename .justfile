_default:
    @just --list

# Build game for mac os
[group('build')]
build_mac:
	mkdir -p build/mac
	unzip bin/love2d_mac.zip -d build/mac/
	mv build/mac/love.app build/mac/Bubblenauts.app
	zip -9 -r build/mac/Bubblenauts.app/Contents/Resources/Bubblenauts.love . -x 'build/**' '.git/**' 'bin/**'

	xmlstarlet ed \
		-u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]" \
		-v "Bubblenauts" build/mac/Bubblenauts.app/Contents/Info.plist

	xmlstarlet ed --inplace \
		-d "/plist/dict/key[text()='UTExportedTypeDeclarations']/following-sibling::*[1]" \
		-u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]"       -v "com.globalgamejam.Bubblenauts" \
		-u "/plist/dict/key[text()='CFBundleIdentifier']/following-sibling::string[1]" -v "Bubblenauts" \
		build/mac/Bubblenauts.app/Contents/Info.plist

	xmlstarlet ed --inplace \
		-d "/plist/dict/key[text()='UTExportedTypeDeclarations']" \
		build/mac/Bubblenauts.app/Contents/Info.plist


# Build game for all of our targets
[group('build')]
build: build_mac
	echo "Finishede building for all systems."


[group('util')]
clean:
	rm -rf build


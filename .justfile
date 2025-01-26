_default:
    @just --list

# Build game for mac os
[group('build')]
build_mac:
	mkdir -p build/mac
	unzip love_zips/love2d_mac.zip -d build/mac/
	mv build/mac/love.app build/mac/Bubblenaut.app
	zip -9 -r build/mac/Bubblenaut.app/Contents/Resources/Bubblenaut.love . -x 'build/**' '.git/**' 'love_zips/**'

	xmlstarlet ed \
		-u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]" \
		-v "Bubblenaut" build/mac/Bubblenaut.app/Contents/Info.plist

	xmlstarlet ed --inplace \
		-d "/plist/dict/key[text()='UTExportedTypeDeclarations']/following-sibling::*[1]" \
		-u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]"       -v "com.globalgamejam.Bubblenaut" \
		-u "/plist/dict/key[text()='CFBundleIdentifier']/following-sibling::string[1]" -v "Bubblenaut" \
		build/mac/Bubblenaut.app/Contents/Info.plist

	xmlstarlet ed --inplace \
		-d "/plist/dict/key[text()='UTExportedTypeDeclarations']" \
		build/mac/Bubblenaut.app/Contents/Info.plist

# Build game for windows
[group('build')]
build_windows:
	mkdir -p build/windows
	unzip love_zips/love2d_win32.zip -d build/windows/
	zip -9 -r build/windows/Bubblenaut.love . -x 'build/**' '.git/**' 'love_zips/**'
	cat build/windows/love-11.5-win32/love.exe build/windows/Bubblenaut.love > build/windows/love-11.5-win32/Bubblenaut.exe
	zip -9 -r build/windows/Bubblenaut.zip build/windows/love-11.5-win32


# Build game for windows
[group('build')]
build_windows:
	mkdir -p build/windows
	unzip love_zips/love2d_win32.zip -d build/windows/
	zip -9 -r build/windows/Bubblenauts.love . -x 'build/**' '.git/**' 'love_zips/**'
	cat build/windows/love-11.5-win32/love.exe build/windows/Bubblenauts.love > build/windows/Bubblenauts.exe
	rm -r build/windows/Bubblenauts.love build/windows/love-11.5-win32




# Build game for all of our targets
[group('build')]
build: build_mac build_windows
	echo "Finishede building for all systems."


[group('util')]
clean:
	rm -rf build


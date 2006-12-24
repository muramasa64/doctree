#@since 1.8.5
= reopen Kernel

== Private Instance Methods

--- Pathname(path)

文字列 path を元に Pathname オブジェクトを生成する。

Pathanme.new(string) と同じ。
#@end



= class Pathname < Object

パス名クラス

== Constants

#@since 1.8.5
--- SEPARATOR_PAT

--- TO_PATH

#@end

== Class Methods

--- new(path)

文字列 path を元に Pathname オブジェクトを生成する。

--- getwd
--- pwd

カレントディレクトリを元に Pathname オブジェクトを生成する。
Pathname.new(Dir.getwd) と同じ。

--- glob(pattern)
--- glob(pattern) {|pathname| ...}
--- glob(pattern[, flags])
--- glob(pattern[, flags]) {|pathname| ...}

ワイルドカードの展開を行なった結果を、
Pathname オブジェクトの配列として返す。

引数の意味は、[[m:Dir.glob]] と同じ。

ブロックが与えられたときは、
ワイルドカードにマッチした Pathname オブジェクトを引数として
そのブロックを 1 つずつ評価し nil を返す。

== Instance Methods

--- ==(other)
--- ===(other)
--- eql?(other)

パス名の比較。other と同じなら真を返す。大文字小文字は区別される。
other は Pathname オブジェクトでなければならない。

パス名の比較は単純にパス文字列の比較によって行われるので論理的に
同じパスでも異なると判断される。

    require 'pathname'

    p Pathname.new("foo/bar") == Pathname.new("foo/bar")
    p Pathname.new("foo/bar") == Pathname.new("foo//bar")
    p Pathname.new("foo/../foo/bar") == Pathname.new("foo/bar")

    # => true
         false
         false

--- <=>(other)

パス名の比較。other と同じなら 0 を、ASCII順で self が大きい場合は
正、other が大きい場合は負を返す。大文字小文字は区別される。

other は Pathname オブジェクトでなければならない。

パス名の比較は単純にパス文字列の比較によって行われるので論理的に
同じパスでも異なると判断される。

    require 'pathname'

    p Pathname.new("foo/bar") <=> Pathname.new("foo/bar")
    p Pathname.new("foo/bar") <=> Pathname.new("foo//bar")
    p Pathname.new("foo/../foo/bar") <=> Pathname.new("foo/bar")
    => 0
       1
       -1

--- hash

ハッシュ値を返す。

--- to_s
--- to_str

パス名を文字列で返す。

to_str は、[[m:File.open]] などの引数にそのまま Pathname オブジェクトを
渡せるように用意してある。

    require 'pathname'

    path = Pathname.new("/tmp/hogehoge")
    File.open(path)

--- cleanpath(consider_symlink = false)

余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返す。

    require "pathname"
    path = Pathname.new("//.././../")
    p path                  # => #<Pathname://.././../>
    p path.cleanpath        # => #<Pathname:/>

consider_symlink が真ならパス要素にシンボリックリンクがあった場合
にも問題ないように .. を残す。

cleanpath は、実際にファイルシステムを参照することなく。文字列操作
だけで処理を行う。

    require 'pathname'

    Dir.rmdir("/tmp/foo")      rescue nil
    File.unlink("/tmp/bar/foo") rescue nil
    Dir.rmdir("/tmp/bar")      rescue nil

    Dir.mkdir("/tmp/foo")
    Dir.mkdir("/tmp/bar")
    File.symlink("../foo", "/tmp/bar/foo")
    path = Pathname.new("bar/././//foo/../bar")

    Dir.chdir("/tmp")

    p path.cleanpath
    p path.cleanpath(true)

    => ruby 1.8.0 (2003-10-10) [i586-linux]
       #<Pathname:bar/bar>
       #<Pathname:bar/foo/../bar>

--- realpath(force_absolute = true)

余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返す。

ファイルシステムをアクセスし、実際に存在するパスを返す。
シンボリックリンクも解決される。

force_absolute が真の場合、絶対パスを返す。self が相対パスであれば、
カレントディレクトリからの相対パスとして解釈される。

self が指すパスが存在しない場合は例外
[[c:Errno::ENOENT]] が発生する。

    require 'pathname'

    Dir.rmdir("/tmp/foo")      rescue nil
    File.unlink("/tmp/bar/foo") rescue nil
    Dir.rmdir("/tmp/bar")      rescue nil

    Dir.mkdir("/tmp/foo")
    Dir.mkdir("/tmp/bar")
    File.symlink("../foo", "/tmp/bar/foo")
    path = Pathname.new("bar/././//foo/../bar")

    Dir.chdir("/tmp")

    p path.realpath
    p path.realpath(false)

    => ruby 1.8.0 (2003-10-10) [i586-linux]
       #<Pathname:/tmp/bar>
       #<Pathname:bar>

--- parent

self の親ディレクトリを指す新しい Pathname オブジェクトを返す。

--- mountpoint?

self がマウントポイントであれば真を返す。

--- root?

self がルートディレクトリであれば真を返す。判断は文字列操作によっ
て行われ、ファイルシステムはアクセスされない。

--- absolute?

self が絶対パス指定であれば真を返す。

--- relative?

self が相対パス指定であれば真を返す。

--- each_filename {|v| ... ]

self のパス名要素毎にブロックを実行する。

    require 'pathname'

    Pathname.new("/foo/../bar").each_filename {|v| p v}

    # => "foo"
         ".."
         "bar"

--- +(other)

パス名を連結する。つまり、other を self からの相対パスとした新しい
Pathname オブジェクトを生成して返す。

other が絶対パスなら単に other を Pathname オブジェクトとして返す。

other は文字列か Pathname オブジェクト。

#@since 1.8.1

--- children

self 配下にあるパス名(Pathnameオブジェクト)の配列を返す。

    require 'pathname'

    p Pathname.new("/tmp").children
    => ruby 1.8.0 (2003-10-10) [i586-linux]
       [#<Pathname:.X11-unix>, #<Pathname:.iroha_unix>, ... ]

".", ".." は要素に含まれない。

self が存在しないパスであったりディレクトリでなければ例外
[[c:Errno::EXXX]] が発生する。

#@end

#@since 1.8.1

--- relative_path_from(base_directory)

base_direcoty から self への相対パスを求め Pathname オブジェクトを
生成して返す。

パス名の解決は文字列操作によって行われ、ファイルシステムをアクセス
しない。

    require 'pathname'

    path = Pathname.new("/tmp/foo")
    base = Pathname.new("/tmp")

    p path.relative_path_from(base)

    # => ruby 1.8.0 (2003-10-10) [i586-linux]
         #<Pathname:foo>

self が相対パスなら base_directory も相対パス、self が絶対パスなら
base_directory も絶対パスでなければならない。

base_directory は Pathname オブジェクトでなければならない。

#@end

#@since 1.8.1

--- each_line(*args, &block)

Equivalent to:
IO.foreach(self.to_s, *args, &block)

#@end

--- read(*args)

Equivalent to:
IO.read(self.to_s, *args)

--- readlines(*args)

Equivalent to:
IO.readlines(self.to_s, *args)

--- sysopen(*args)

Equivalent to:
IO.sysopen(self.to_s, *args)

--- atime

Equivalent to:
File.atime(self.to_s)

--- ctime

Equivalent to:
File.ctime(self.to_s)

--- mtime

Equivalent to:
File.mtime(self.to_s)

--- chmod(mode)

Equivalent to:
File.chmod(mode, self.to_s)

--- lchmod(mode)

Equivalent to:
File.chmod(mode, self.to_s)

--- chown(owner, group)

Equivalent to:
File.chown(owner, group, self.to_s)

--- lchown(owner, group)

Equivalent to:
File.lchown(owner, group, self.to_s)

--- fnmatch(pattern, *args)

Equivalent to:
File.fnmatch(pattern, self.to_s, *args)

--- fnmatch?(pattern, *args)

Equivalent to:
File.fnmatch?(pattern, self.to_s, *args)

--- ftype

Equivalent to:
File.ftype(self.to_s)

--- link(old)

Equivalent to:
File.link(old, self.to_s)

--- open(*args, &block)

Equivalent to:
File.open(self.to_s, *args, &block)

--- readlink

Equivalent to:
Pathname.new(File.readlink(self.to_s))

--- rename(to)

Equivalent to:
File.rename(self.to_s, to)

--- stat

Equivalent to:
File.stat(self.to_s)

--- lstat

Equivalent to:
File.lstat(self.to_s)

--- symlink(old)

Equivalent to:
File.symlink(old, self.to_s)

--- truncate(length)

Equivalent to:
File.truncate(self.to_s, length)

--- utime(atime, mtime)

Equivalent to:
File.utime(atime, mtime, self.to_s)

--- basename(*args)

Equivalent to:
Pathname.new(File.basename(self.to_s, *args))

--- dirname

Equivalent to:
Pathname.new(File.dirname(self.to_s))

--- extname

Equivalent to:
File.extname(self.to_s)

--- expand_path(*args)

Equivalent to:
Pathname.new(File.expand_path(self.to_s, *args))

--- join(*args)

Equivalent to:
Pathname.new(File.join(self.to_s, *args))

--- split

Equivalent to:
File.split(self.to_s)

--- blockdev?

Equivalent to:
FileTest.blockdev?(self.to_s)

--- chardev?

Equivalent to:
FileTest.chardev?(self.to_s)

--- executable?

Equivalent to:
FileTest.executable?(self.to_s)

--- executable_real?

Equivalent to:
FileTest.executable_real?(self.to_s)

--- exist?

Equivalent to:
FileTest.exist?(self.to_s)

--- grpowned?

Equivalent to:
FileTest.grpowned?(self.to_s)

--- directory?

Equivalent to:
FileTest.directory?(self.to_s)

--- file?

Equivalent to:
FileTest.file?(self.to_s)

--- pipe?

Equivalent to:
FileTest.pipe?(self.to_s)

--- socket?

Equivalent to:
FileTest.socket?(self.to_s)

--- owned?

Equivalent to:
FileTest.owned?(self.to_s)

--- readable?

Equivalent to:
FileTest.readable?(self.to_s)

--- readable_real?

Equivalent to:
FileTest.readable_real?(self.to_s)

--- setuid?

Equivalent to:
FileTest.setuid?(self.to_s)

--- setgid?

Equivalent to:
FileTest.setgid?(self.to_s)

--- size

Equivalent to:
FileTest.size(self.to_s)

--- size?

Equivalent to:
FileTest.size?(self.to_s)

--- sticky?

Equivalent to:
FileTest.sticky?(self.to_s)

--- symlink?

Equivalent to:
FileTest.symlink?(self.to_s)

--- writable?

Equivalent to:
FileTest.writable?(self.to_s)

--- writable_real?

Equivalent to:
FileTest.writable_real?(self.to_s)

--- zero?

Equivalent to:
FileTest.zero?(self.to_s)

--- rmdir

Equivalent to:
Dir.rmdir(self.to_s)

--- entries

Equivalent to:
Dir.entries(self.to_s)

#@since 1.8.1

--- each_entry {|pathname| ... }

Equivalent to:
Dir.foreach(self.to_s) {|f| yield Pathname.new(f) }

#@end

--- mkdir(*args)

Equivalent to:
Dir.mkdir(self.to_s, *args)

--- opendir(&block)

Equivalent to:
Dir.open(self.to_s, &block)

--- find {|pathname| ...}

self 配下のすべてのファイルやディレクトリを
一つずつ引数 pathname に渡してブロックを実行する。

  require 'find'
  Find.find(self.to_s) {|f| yield Pathname.new(f)}

と同じ。

--- mkpath

Equivalent to:
FileUtils.mkpath(self.to_s)

--- rmtree

Equivalent to:
FileUtils.rm_r(self.to_s)

--- unlink
--- delete

self が指すディレクトリあるいはファイルを削除する。

#@since 1.8.5

--- ascend

#@end

--- chdir

--- chroot

#@if(version <= "1.8.1")

--- cleanpath_aggressive

--- cleanpath_conservative

#@end

#@since 1.8.5
--- descend

#@end

--- dir_foreach

--- foreach

--- foreachline

#@since 1.8.2
--- freeze

#@end

--- inspect

#@since 1.8.1
--- make_link


--- make_symlink

#@end

#@if(version <= "1.8.0")
--- realpath_rec

--- realpath_root?

#@end


#@since 1.8.5
--- sub

#@end

#@since 1.8.2
--- taint

--- untaint

#@end

#@since 1.9.0
--- to_path

#@end

#@since 1.8.5

--- world_readable?

--- world_writable?

#@end

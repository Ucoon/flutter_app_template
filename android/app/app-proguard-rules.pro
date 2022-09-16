# app 混淆规则

#指定代码的压缩级别
-optimizationpasses 5

# 指定不去忽略非公共的库的类的成员
-dontskipnonpubliclibraryclassmembers

# 有了verbose这句话，混淆后就会生成映射文件
# 包含有类名->混淆后类名的映射关系
# 然后使用printmapping指定映射文件的名称
-verbose
-printmapping priguardMapping.txt


# 指定混淆时采用的算法，后面的参数是一个过滤器
# 这个过滤器是谷歌推荐的算法，一般不改变
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# 抛出异常时保留代码行号
-keepattributes SourceFile,LineNumberTable
#不混淆内部类
-keepattributes InnerClasses
#不混淆注解类
-keepattributes *Annotation*
#不混淆异常
-keepattributes Exceptions
#不混淆签名
-keepattributes Signature


# 枚举类不能被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
# 阿里云推送的混淆规则
-include ali-push-proguard-rules.pro


#apk 包内所有 class 的内部结构
-dump class_files.txt
#未混淆的类和成员
-printseeds seeds.txt
#列出从 apk 中删除的代码
-printusage unused.txt
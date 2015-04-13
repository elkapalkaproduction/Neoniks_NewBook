//
//  NNKEpubToChaptersConverter.m
//  Reader
//
//  Created by Andrei Vidrasco on 1/10/15.
//  Copyright (c) 2015 Andrei Vidrasco. All rights reserved.
//

#import "NNKEpubToChaptersConverter.h"
#import "ZipArchive.h"
#import "NNKChapter.h"

static NSString *const kMediaTypeKey = @"media-type";
static NSString *const kHrefTypeKey = @"href";
static NSString *const kOPFKey = @"opf";
static NSString *const kNCXKey = @"ncx";
static NSString *const kNCXMapping = @"http://www.daisy.org/z3986/2005/ncx/";
static NSString *const kIDRefKey = @"idref";
static NSString *const kIDKey = @"id";
static NSString *const kIDPFKey = @"http://www.idpf.org/2007/opf";
static NSString *const kOPFItemKey = @"//opf:item";
static NSString *const kOPFItemRefKey = @"//opf:itemref";

@interface NNKEpubToChaptersConverter ()

@property (nonatomic, strong) NSString *epubFilePath;
@property (weak, nonatomic) ActionBlock completionBlock;

@end

@implementation NNKEpubToChaptersConverter

- (void)convertWithEpubPath:(NSString *)path completionBlock:(ActionBlock)completion {
    self.epubFilePath = path;
    self.completionBlock = completion;
    [self parseEpub];
}


- (void)parseEpub {
    [self unzipAndSaveFileNamed:self.epubFilePath];

    NSString *opfPath = [self extractOPFFileName];
    [self parseOPF:opfPath];
}


- (void)unzipAndSaveFileNamed:(NSString *)fileName {
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    if ([zipArchive UnzipOpenFile:self.epubFilePath]) {
        [self deleteAllPreviousFilesAtPath:[self baseEpubPath]];

        //start unzip
        BOOL ret = [zipArchive UnzipFileTo:[self basePathWithLastPathComponent:@"/"]
                                 overWrite:YES];
        NSAssert(ret, @"Error when unziping");
        [zipArchive UnzipCloseFile];
    }
}


- (NSString *)extractOPFFileName {
    NSString *manifestFilePath = [self basePathWithLastPathComponent:@"META-INF/container.xml"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSAssert([fileManager fileExistsAtPath:manifestFilePath], @"ERROR: ePub not Valid");

    CXMLDocument *manifestFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath]
                                                                     options:0
                                                                       error:nil];
    CXMLNode *opfPath = [manifestFile nodeForXPath:@"//@full-path[1]"
                                             error:nil];

    return [opfPath stringValue];
}


- (NSDictionary *)extractItemDictionaryFromItemsArray:(NSArray *)itemsArray {
    NSMutableDictionary *itemDictionary = [NSMutableDictionary dictionary];
    for (CXMLElement *element in itemsArray) {
        NSString *key = [[element attributeForName:kIDKey] stringValue];
        NSString *value = [[element attributeForName:kHrefTypeKey] stringValue];
        itemDictionary[key] = value;
    }

    return [NSDictionary dictionaryWithDictionary:itemDictionary];
}


- (NSString *)extractNCXFileNameFromItemsArray:(NSArray *)itemsArray {
    for (CXMLElement *element in itemsArray) {
        NSString *value = [[element attributeForName:kHrefTypeKey] stringValue];
        if ([[value pathExtension] isEqualToString:kNCXKey]) {
            return value;
        }
    }
    
    return nil;
}


- (NSDictionary *)extractTitleDictionaryFromItemsArray:(NSArray *)itemsArray {
    NSString *ncxFileName = [self extractNCXFileNameFromItemsArray:itemsArray];
    NSURL *tocNCXURL = [NSURL fileURLWithPath:[self basePathWithLastPathComponent:ncxFileName]];
    CXMLDocument *ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:tocNCXURL
                                                               options:0
                                                                 error:nil];
    
    NSMutableDictionary *titleDictionary = [NSMutableDictionary dictionary];
    NSDictionary *namespaceMappings = @{kNCXKey : kNCXMapping};

    for (CXMLElement *element in itemsArray) {
        NSString *href = [[element attributeForName:kHrefTypeKey] stringValue];
        NSString *xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];

        NSArray *navPoints = [ncxToc nodesForXPath:xpath
                                 namespaceMappings:namespaceMappings
                                             error:nil];
        NSString *title = [[navPoints firstObject] stringValue];
        if (title) {
            [titleDictionary setValue:title forKey:href];
        }
    }

    return [NSDictionary dictionaryWithDictionary:titleDictionary];
}


- (NSArray *)extractChaptersFromTitleDictionary:(NSDictionary *)titleDictionary
                                 itemDictionary:(NSDictionary *)itemDictionary
                                  itemRefsArray:(NSArray *)itemRefsArray {
    NSMutableArray *tmpArray = [NSMutableArray array];
    int count = 0;

    for (CXMLElement *element in itemRefsArray) {
        NSString *chapHref = itemDictionary[[[element attributeForName:kIDRefKey] stringValue]];
        NNKChapter *tmpChapter = [[NNKChapter alloc] initWithPath:[self basePathWithLastPathComponent:chapHref]
                                                      title:[titleDictionary valueForKey:chapHref]
                                               chapterIndex:count++];
        [tmpArray addObject:tmpChapter];
    }

    return [NSArray arrayWithArray:tmpArray];
}


- (void)parseOPF:(NSString *)opfFileName {
    NSString *opfPath = [self basePathWithLastPathComponent:opfFileName];
    CXMLDocument *opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath]
                                                                options:0
                                                                  error:nil];
    NSDictionary *namespaceDict = @{kOPFKey : kIDPFKey};
    NSArray *itemsArray = [opfFile nodesForXPath:kOPFItemKey
                               namespaceMappings:namespaceDict
                                           error:nil];
    NSArray *itemRefsArray = [opfFile nodesForXPath:kOPFItemRefKey
                                  namespaceMappings:namespaceDict
                                              error:nil];
    NSDictionary *itemDictionary = [self extractItemDictionaryFromItemsArray:itemsArray];
    NSDictionary *titleDictionary = [self extractTitleDictionaryFromItemsArray:itemsArray];
    NSArray *resultArray = [self extractChaptersFromTitleDictionary:titleDictionary
                                                     itemDictionary:itemDictionary
                                                      itemRefsArray:itemRefsArray];
    if (self.completionBlock) {
        self.completionBlock(resultArray);
    }
}


- (void)deleteAllPreviousFilesAtPath:(NSString *)strPath {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:strPath]) {
        NSError *error;
        [filemanager removeItemAtPath:strPath error:&error];
    }
}


- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;

    return basePath;
}


- (NSString *)baseEpubPath {
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"UnzippedEpub"];
}


- (NSString *)basePathWithLastPathComponent:(NSString *)lastPathComponent {
    return [[self baseEpubPath] stringByAppendingPathComponent:lastPathComponent];
}

@end

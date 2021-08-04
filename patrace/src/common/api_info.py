from __future__ import print_function
import os.path
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import specs.stdapi as stdapi
import specs.gles12api as gles12api
import specs.eglapi as eglapi

# global variables
gMaxId = 0
gIdToFunc = {}
gIdToLength = {}
api = stdapi.API()


class TypeLengthVisitor(stdapi.Visitor):
    def __init__(self):
        self.len = 'variable'

    def visitVoid(self, void):
        self.len = '0'

    def visitLiteral(self, literal):
        self.len = 'PAD_SIZEOF(%s)' % (literal)

    def visitString(self, string):
        pass

    def visitConst(self, const):
        self.visit(const.type)

    def visitStruct(self, struct):
        pass

    def visitArray(self, array):
        # TODO LZ:
        pass

    def visitBlob(self, blob):
        pass

    def visitEnum(self, enum):
        self.len = 'PAD_SIZEOF(int)'

    def visitBitmask(self, bitmask):
        self.visit(bitmask.type)

    def visitPointer(self, pointer):
        pass

    def visitIntPointer(self, pointer):
        self.len = 'PAD_SIZEOF(int)'

    def visitObjPointer(self, pointer):
        pass

    def visitLinearPointer(self, pointer):
        pass

    def visitReference(self, reference):
        pass

    def visitHandle(self, handle):
        self.visit(handle.type)
        # TODO: LZ:

    def visitAlias(self, alias):
        self.visit(alias.type)

    def visitOpaque(self, opaque):
        pass

    def visitInterface(self, interface):
        pass

    def visitPolymorphic(self, polymorphic):
        pass


def funcSerializedLength(func):
    funcLen = 'sizeof(BCall)'
    visitor = TypeLengthVisitor()
    visitor.visit(func.type)
    if visitor.len == 'variable':
        return '0'
    funcLen += ('+'+visitor.len)
    for arg in func.args:
        visitor.len = 'variable'
        visitor.visit(arg.type)
        if visitor.len == 'variable':
            return '0'
        funcLen += ('+'+visitor.len)
    return funcLen


def parseFunctions(functions):
    global gMaxId
    global gIdToFunc
    global gIdToLength

    for func in functions:
        if func.id > gMaxId:
            gMaxId = func.id
    gIdToFunc = dict([(func.id, func) for func in functions])
    gIdToLength = dict([func.id, funcSerializedLength(func)] for func in functions)


def sigBook(functions):
    global gMaxId
    global gIdToFunc

    print('const char* ApiInfo::IdToNameArr[%d] = {' % (gMaxId+1))
    for id in range(0, gMaxId+1, 1):
        if id not in gIdToFunc:
            print('    0,')
        else:
            print('    "%s", // %d' % (gIdToFunc[id].name, id))
    print('};')
    print()


def funcLenBook(functions):
    global gMaxId
    global gIdToFunc
    global gIdToLength

    print('int ApiInfo::IdToLenArr[%d] = {' % (gMaxId+1))
    for id in range(0, gMaxId+1, 1):
        if id not in gIdToLength:
            print('    0, // no corresponding function ')
        else:
            print('    %s, // %d, %s' % (gIdToLength[id], id, gIdToFunc[id].name))
    print('};')
    print()


if __name__ == '__main__':

    api.addApi(gles12api.glesapi)
    api.addApi(eglapi.eglapi)
    parseFunctions(api.functions)

    #############################################################
    ##
    script_dir = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(script_dir, 'api_info_auto.cpp')
    sys.stdout = open(file_path, 'w')
    print('//Generated by %s' % sys.argv[0])
    print('#include <common/api_info.hpp>')
    print('#include <common/file_format.hpp>')
    print()
    print('namespace common {')
    print()
    print('unsigned short ApiInfo::MaxSigId = %d;' % gMaxId)
    print()
    sigBook(api.functions)
    funcLenBook(api.functions)
    print('} // namespace common')
    print()

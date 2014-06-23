#ifndef CPF_MORE_H
#define CPF_MORE_H
#include <stdio.h>
#include <stdint.h>

typedef struct CustomPackageFileInfos
    {
	FILE *	filePtr;
	int64_t StartOffset;
        int64_t	TotalSize;
    } CustomPackageFileInfos;

int64_t cpfFileLength(void* UserData);
int64_t cpfFileTell(void* UserData);
int64_t cpfFileSeek(int64_t Offset, int Whence, void* UserData);
int64_t cpfFileRead(void* Ptr, int64_t Count, void* UserData);
int64_t cpfFileWrite(const void *ptr, int64_t count, void *user_data);

#endif

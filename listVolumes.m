
#include <sys/param.h>
#include <sys/mount.h>
#include <sys/ucred.h>
#include <stdio.h>



/**
 \brief determine if the volume mounted at `mountPointPath` is browsable
 
 \returns 0 for no, 1 for yes, or -1 for an error.
 **/

int isVolumeBrowseable(const char* mountPointPath)
{
    int result = 0;
    struct statfs stat;
    int error = statfs(mountPointPath, &stat);
    if (error == 0) {
        result = (stat.f_flags & MNT_DONTBROWSE) == 0;
    } else {
        result = -1;
    }
    return result;
}






char* mountFlagsString(uint32_t flags)
{
    char* output = NULL;
    
    asprintf(&output, "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s", 
             flags & MNT_RDONLY ? "MNT_RDONLY " : "",
             flags & MNT_SYNCHRONOUS ? "MNT_SYNCHRONOUS " : "",
             flags & MNT_NOEXEC ? "MNT_NOEXEC " : "",
             flags & MNT_NOSUID ? "MNT_NOSUID " : "",
             flags & MNT_NODEV ? "MNT_NODEV " : "",
             flags & MNT_UNION ? "MNT_UNION " : "",
             flags & MNT_ASYNC ? "MNT_ASYNC " : "",
             flags & MNT_EXPORTED ? "MNT_EXPORTED " : "",
             flags & MNT_QUARANTINE ? "MNT_QUARANTINE " : "",
             flags & MNT_LOCAL ? "MNT_LOCAL " : "",
             flags & MNT_QUOTA ? "MNT_QUOTA " : "",
             flags & MNT_ROOTFS ? "MNT_ROOTFS " : "",
             flags & MNT_DOVOLFS ? "MNT_DOVOLFS " : "",
             flags & MNT_DONTBROWSE ? "MNT_DONTBROWSE " : "",
             flags & MNT_IGNORE_OWNERSHIP ? "MNT_IGNORE_OWNERSHIP " : "",
             flags & MNT_AUTOMOUNTED ? "MNT_AUTOMOUNTED " : "",
             flags & MNT_JOURNALED ? "MNT_JOURNALED " : "",
             flags & MNT_NOUSERXATTR ? "MNT_NOUSERXATTR " : "",
             flags & MNT_DEFWRITE ? "MNT_DEFWRITE " : "",
             flags & MNT_MULTILABEL ? "MNT_MULTILABEL " : "",
             flags & MNT_NOATIME ? "MNT_NOATIME " : ""
             );
    
    return output;
}


int main (int argc, const char * argv[]) {

    int numMounts = 0, i;
    struct statfs * mountStats = NULL;
    
    numMounts = getmntinfo(&mountStats, 0);
    
    printf("There are %d file systems mounted:\n", numMounts);
    
    for (i = 0; i < numMounts; ++i) {
        char* flagsString = mountFlagsString(mountStats[i].f_flags);
        printf("fs#%2d : %-40s %-40s %08x %d\n        %s\n", i, mountStats[i].f_mntfromname, mountStats[i].f_mntonname, mountStats[i].f_flags,
               isVolumeBrowseable(mountStats[i].f_mntonname),
               flagsString);
        free((void*)flagsString);
    }
    
    free((void*)mountStats);
    
    return 0;
}

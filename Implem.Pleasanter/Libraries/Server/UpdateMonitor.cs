using Implem.Pleasanter.Libraries.Requests;
using Implem.Pleasanter.Models;
using System;
using System.Collections.Generic;
namespace Implem.Pleasanter.Libraries.Server
{
    public class UpdateMonitor
    {
        public DateTime DeptsUpdatedTime;
        public DateTime GroupsUpdatedTime;
        public DateTime UsersUpdatedTime;
        public DateTime PermissionsUpdatedTime;
        public DateTime NowDeptsUpdatedTime;
        public DateTime NowGroupsUpdatedTime;
        public DateTime NowUsersUpdatedTime;
        public DateTime NowPermissionsUpdatedTime;
        public Dictionary<string, DateTime> UpdatedTimeHash;
        public bool Updated;
        public bool DeptsUpdated;
        public bool GroupsUpdated;
        public bool UsersUpdated;
        public bool PermissionsUpdated;

        public UpdateMonitor(Context context)
        {
            Monitor(context: context);
        }

        public void Monitor(Context context)
        {
            Set(context: context);
            DeptsUpdated = DeptsUpdatedTime != NowDeptsUpdatedTime;
            GroupsUpdated = GroupsUpdatedTime != NowGroupsUpdatedTime;
            UsersUpdated = UsersUpdatedTime != NowUsersUpdatedTime;
            PermissionsUpdated = PermissionsUpdatedTime != NowPermissionsUpdatedTime;
            Updated = DeptsUpdated || GroupsUpdated || UsersUpdated || PermissionsUpdated;
        }

        private void Set(Context context)
        {
            var hash = StatusUtilities.Monitors(context: context);
            NowDeptsUpdatedTime = hash[StatusUtilities.Types.DeptsUpdated];
            NowGroupsUpdatedTime = hash[StatusUtilities.Types.GroupsUpdated];
            NowUsersUpdatedTime = hash[StatusUtilities.Types.UsersUpdated];
            NowPermissionsUpdatedTime = hash[StatusUtilities.Types.PermissionsUpdated];
        }

        public void Update()
        {
            DeptsUpdatedTime = NowDeptsUpdatedTime;
            GroupsUpdatedTime = NowGroupsUpdatedTime;
            UsersUpdatedTime = NowUsersUpdatedTime;
            PermissionsUpdatedTime = NowPermissionsUpdatedTime;
        }
    }
}
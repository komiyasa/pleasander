with "CTE"(
    "SiteId",
    "ParentId",
    "ReferenceType",
    "Title",
    "Lv") as
(
    select
        "Sites"."SiteId",
        "Sites"."ParentId",
        "Sites"."ReferenceType",
        "Sites"."Title",
        1
    from
        "Sites" inner join "Permissions" on
        "Sites"."InheritPermission" = "Permissions"."ReferenceId"
    where
        "Sites"."TenantId" = @TenantId_ and
        "Sites"."ReferenceType" = @ReferenceType_ and
        "Sites"."SiteId" <> @SiteId_ and
        (
            @HasPrivilege_=1
            or
            (
                exists
                (
                    select * from "Permissions"
                    where "Permissions"."ReferenceId"="InheritPermission"
                        and "Permissions"."PermissionType" & 4=4
                        and
                        (
                            exists
                            (
                                select * from "Depts"
                                where "Depts"."TenantId"=@_T
                                    and "Depts"."DeptId"=@_D
                                    and "Depts"."Disabled"='false'
                                    and "Permissions"."DeptId"="Depts"."DeptId"
                                    and @_D<>0
                            )
                            or
                            (
                                exists
                                (
                                    select *
                                    from "GroupMembers" inner join "Groups" on "GroupMembers"."GroupId"="Groups"."GroupId"
                                    where "Groups"."TenantId"=@_T
                                        and "Groups"."Disabled"='false'
                                        and "Permissions"."GroupId"="GroupMembers"."GroupId"
                                        and
                                        (
                                            exists
                                            (
                                                select * from "Depts"
                                                where "Depts"."TenantId"=@_T
                                                    and "Depts"."DeptId"=@_D
                                                    and "Depts"."Disabled"='false'
                                                    and "GroupMembers"."DeptId"="Depts"."DeptId"
                                                    and @_D<>0
                                            )
                                            or
                                            (
                                                "GroupMembers"."UserId"=@_U
                                                and @_U<>0
                                            )
                                        )
                                       
                                )
                            )
                            or
                            (
                                (
                                    "Permissions"."UserId"=@_U
                                    or "Permissions"."UserId"=-1
                                )
                                and @_U<>0
                            )
                        )
                )
            )
        )
    union all
    select
        "t1"."SiteId",
        "t1"."ParentId",
        "t1"."ReferenceType",
        "t1"."Title",
        "CTE"."Lv" + 1
    from
        "Sites" as "t1" inner join "CTE" on
        "t1"."SiteId" = "CTE"."ParentId"
)
select distinct
    "CTE"."SiteId",
    "CTE"."ParentId",
    "CTE"."ReferenceType",
    "CTE"."Title"
from "CTE"
where
    "CTE"."ReferenceType" <> 'Wikis';
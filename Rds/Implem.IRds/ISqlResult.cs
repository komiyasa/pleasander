using System.Data;
namespace Implem.IRds
{
    public interface ISqlResult
    {
        int DeleteCount(DataTable data);

        int RestoreCount(DataTable data);
    }
}

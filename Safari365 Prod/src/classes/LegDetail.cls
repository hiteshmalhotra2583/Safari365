public class LegDetail
{
    public String LegStartLocation{get;set;}
    public String LegEndLocation{get;set;}
    public Date LegStartDate{get;set;}
    public Date LegEndDate{get;set;}
    public Integer LegSequence{get;set;}
    public List<LegDayDetail> LegDayDetails{get;set;}
}
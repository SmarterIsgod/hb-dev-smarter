using TreeSharp;

namespace AOEDruid
{
    public partial class AOEDruid
    {
        private static Composite CreateRestBehavior()
        {
            return new PrioritySelector(
                new NeedEat(new Eat()));
        }
    }
}
using TreeSharp;

namespace AOEDruid
{
    public partial class AOEDruid
    {
        private Composite CreateCombatBehavior()
        {
            return new PrioritySelector(
                new NeedCatForm(new CastCatForm()),
                new NeedMoveTo(new MoveTo()),
                new NeedSurvivalInstincts(new BuffSurvivalInstincts()),
                new NeedRejuvenation(new BuffRejuvenation()),
                new NeedBarkskin(new BuffBarksin()),
                new NeedMotW(new BuffMotW()),
                new CanRavage(new CastRavage()),
                new CanTigerFury(new CastTigerFury()),
                new CanBerserk(new CastBerserk()),
                new Decorator(ret => _combatTargets > 1,
                              new CanSwipe(new CastSwipe())),
                new Decorator(ret => _combatTargets < 2,
                              new CanMangle(new CastMangle()))
                );
        }
    }
}
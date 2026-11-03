package instrument

import (
	"errors"
	"fmt"
)

var ErrResearchUnsupported = errors.New("قابلیت اجرای پژوهش برای این جفت فعال نیست")

// ResearchPolicy changes when application research eligibility changes.
const ResearchPolicy = "known-usdt/v1"

// ResearchError is the application capability gate; valuation primitives remain general.
func ResearchError(symbol string) error {
	for _, s := range Defaults() {
		if s.Symbol != symbol {
			continue
		}
		if s.Quote != USDT {
			return fmt.Errorf("%w: \u2066%s\u2069؛ فعلاً فقط جفت‌های USDT مجازند؛ تأمین دارایی مظنه و حسابداری متقاطع هنوز پشتیبانی نمی‌شود", ErrResearchUnsupported, symbol)
		}
		return nil
	}
	return fmt.Errorf("%w: نماد \u2066%s\u2069 برای پژوهش پشتیبانی نمی‌شود", ErrResearchUnsupported, symbol)
}
